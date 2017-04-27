# Clint Valentine
# 04/11/2017
#rm(list = ls())

library(aws.s3)
library(itertools)
library(RSQLite)
library(stringr)

# Code to install cloudyr (not on CRAN) on a Windows OS.
#
# install.packages("aws.s3",
#                  repos=c("cloudyr" = "http://cloudyr.github.io/drat"),
#                  INSTALL_opts="--no-multiarch")

# AWS CLI must be installed and properly configured.
credentials <- aws.signature::read_credentials()

parse.sample.sheet.object <- function(object) {
  # Stream the contents of the object, decompress, make text connection,
  # and read in lines. Split them on commas, trimws, and unlist.
  sample.sheet <- readLines(textConnection(rawToChar(get_object(object))))
  sample.sheet <- lapply(
    sample.sheet, function(x) trimws(unlist(strsplit(x, ','))))
  
  # Initalize all containers for this SampleSheet.
  config <- list(
    header = list(),
    reads = c(),
    settings = list(),
    data = list()
  )
  
  # Create a special iterator which can be advanced manually and exhausted.
  handle <- itertools::ihasNext(sample.sheet)
  while ( hasNext(handle) ) {
    # Split line on comma.
    line <- unlist(strsplit(nextElem(handle), split=','))
    
    # If this is an empty line, skip!
    if ( all(line == '') ) { next }
    
    # If this row matches a section pattern save section name and advance.
    section_match = str_match(string=line[1], pattern='\\[(.*)\\]')
    if ( any(!is.na(section_match)) ) {
      # Enforce that section names are always lowercase going forward.
      section = str_to_lower(section_match[2])
      next
    }
    
    # Handle data separately for each section group. [Header] and [Settings]
    # just happen to follow .ini convention. [Reads] and [Data] do not.
    if( section %in% c('header', 'settings') ) {
      config[[section]][[gsub(' ', '', line[1])]] <- line[2]
    }
    # [Reads] are a vertical list of read lengths, at most two rows.
    else if ( section %in% c('reads') ) {
      config[[section]] <- c(config[[section]], as.numeric(line[1]))
    }
    # [Data] are represented as a subsheet with a header row and samples
    # following that header row. If we encounter our first row, save it as a
    # header, then advance to samples and save each in a zipped list with the
    # header row as names.
    else if ( section %in% c('data') ) {
      if ( length(config[[section]]) == 0 ) {
        sample_header = line
        line = nextElem(handle)
      }
      # Append a new list of sample metadata to the growing list of samples.
      config[[section]] <- append(
        config[[section]],
        list(setNames(as.list(line), sample_header)))
    }
  }
  return(config)
}


get.sample.sheet.config <- function(run, max=1000) {
  # Null if run does not exist or connection cannot be established.
  config <- NULL
  
  # To minimize GET requests to AWS we must specify the prefix of the run
  # folder and the delimiter to force `get_bucket` to return only file objects
  # one directory deep. Without this, `get_bucket` will return over a million
  # object keys!
  bucket <- get_bucket(
    bucket='twinstrand-run-folders',
    prefix=paste(run, '/', sep=''),
    delimiter='/',
    max=max,
    key=credentials$default$AWS_ACCESS_KEY_ID,
    secret=credentials$default$AWS_SECRET_ACCESS_KEY
  )
  
  for ( object in bucket ) {
    # Skip any object that is not a SampleSheet, case-insensitive.
    if ( grepl('samplesheet', str_to_lower(object$Key)) == F ) { next }
    
    cat('\n[   INFO   ] Discovered', object$Key)
    cat('\n[   INFO   ] Parsing', run)
    
    # Stream the SampleSheet and parse it into an organized data structure.
    config <- parse.sample.sheet.object(object)
    }
  return(config)
}


make.sample.sheet.database <- function(name, overwrite=F) {
  cat('\n[  CONNECT ] Connecting to database:', name)
  conn <- dbConnect(RSQLite::SQLite(), dbname=name)
  
  for ( table in c('runs', 'samples') ) {
    if ( table %in% dbListTables(conn) && overwrite == T ) {
      cat('\n[  WARNING ] Dropping table:', table)
      dbRemoveTable(conn, table)   
    }
  }
  
  if ( !'runs' %in% dbListTables(conn) ) {
    cat('\n[   INFO   ] Creating table:', 'runs')
    dbGetQuery(conn=conn,
      'CREATE TABLE runs
        (run TEXT,
         IEM1FileVersion INTEGER,
         InvestigatorName TEXT,
         ExperimentName TEXT,
         Date TEXT,
         Workflow TEXT,
         Application TEXT,
         Assay TEXT,
         Description TEXT,
         Chemistry TEXT,
         Paired BIT,
         ReadLength INTEGER
         CreateFastqForIndexReads BIT
         BarcodeMismatches INTEGER
         a)')
  }
  
  if ( !'samples' %in% dbListTables(conn) ) {
    cat('\n[   INFO   ] Creating table:', 'samples')
    dbGetQuery(conn=conn,
      'CREATE TABLE samples
       (run TEXT,
        Sample_ID TEXT,
        Sample_Name TEXT,
        Library_ID TEXT,
        Sample_Project TEXT,
        Description TEXT,
        index1 TEXT,
        index2 TEXT,
        Target_Set TEXT,
        Reference_Name TEXT,
        Read_Structure TEXT,
        Fixed_Umi_Set_Name TEXT)')
  }
}


add.run.to.db <- function(run, dbname) {
  conn <- dbConnect(RSQLite::SQLite(), dbname=dbname)
  
  # Check if run record already exists in database, if so skip this iteration.
  response <- dbGetQuery(conn=conn,
    paste('SELECT EXISTS(
           SELECT * FROM runs 
           WHERE run = "', run, '")',
          sep=''))
  
  if ( response == T ) {
    cat('\n[   INFO   ] Run already in database', run)
    return(NULL)
  }
  
  # Since the record does not exist we will scrape and parse the source file
  # from AWS and prepare it for inclusion into our database.
  config <- get.sample.sheet.config(run)
  
  # Check to see if Illumina reads are paired-end or not.
  if ( length(config[['reads']]) == 2 ) { paired = 1 } else { paired = 0 }
  
  # Compose a data.frame of all fields and their values to append to the
  # run database.
  run.table <- data.frame(list(
    run=run,
    config[['header']],
    Paired=paired,
    ReadLength=config[['reads']][1]
  ))
  
  # Write record to database, ensuring that we append.
  dbWriteTable(conn, 'runs', run.table, append=T)
  cat('\n[ DB WRITE ] Run', run, 'added to database', dbname)
  
  for ( sample in config$data ) {
    # Compose a data.frame of all samples with the primary key `run`` and append
    # to the samples database.
    sample.table <- data.frame(list(run=run, sample))
    
    # WARNING: hack since Illumina named a field `index` which collides with
    # SQL syntax. Need to find a more dynamic method for replacement.
    colnames(sample.table)[7] <- 'index1'
    
    dbWriteTable(conn, 'samples', sample.table, append=T)
  }
  cat('\n[ DB WRITE ] From run', run, 'added', length(config$data),
      'sample records to database', dbname)
}

# MAIN #########################################################################

overwrite <- T
dbname <- 'sample_sheets.sqlite'

runs <- c(
  '170126_NB501910_0002_AHHJWLBGX2',
  '170210_NB501910_0004_AHJLMYAFXX',
  '170217_NB501910_0005_AHJY3LAFXX',
  '170302_NB501910_0006_AHJK23AFXX',
  '170303_NB501910_0007_AHHFVNBGX2',
  '170313_NB501910_0009_AHHHTFBGX2',
  '170317_NB501910_0010_AHJLFJAFXX',
  '170320_NB501910_0011_AHKJNHBGX2',
  '170331_NB501910_0012_AHJKNWAFXX',
  '170407_NB501910_0013_AHJKVVAFXX'
)

make.sample.sheet.database(dbname, overwrite=overwrite)


for ( run in runs ) {
  add.run.to.db(run, dbname)
}




