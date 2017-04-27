# Clint Valentine
# 01/25/2017
rm(list = ls())

require(stringr)

# In an attempt to vectorize as many operations as possible the file is opened
# and then scanned to the first entry. The rest of the file is loaded into memory
# and then string operations cleanup each entry line such that a regex pattern
# can extract all catagorical fields. Finally, the cleaned data is saved to disk
# and returned as a data.frame.

preprocessEntries <- function(infile) {
  if ( file.exists('entries.Rdata') == F ) {
    connection <- file(description = infile, open = 'r')
    
    # Consume the first 15 lines of non-information and save the rest.
    readLines(connection, n = 15, warn = F)
    entries <- readLines(connection)
  
    # Trim whitespace, and replace any multiple tabs with a single space.
    entries <- gsub("\\t+", " ", str_trim(entries))
  
    # Replace any escaped quotations with a '+' symbol for use in regex later.
    entries <- gsub("\"", "", entries, fixed=T)
    
    # Parse tokens in each entry and coerce into a data.frame.
    # Match pattern is constructed as following:
    # 1. Name: Capture anythin but parenthesis before a space followed by a left parenthesis.
    # 2. Year: Capture 4 atoms in between two parenthesis.
    # 3. Metdata: Capture anything that exists before the final word (usually a date interval).
    # 4. Release Year: Capture anything not a space at the end of string.
    pattern <- '^([^\\(\\) ]*?) \\((.{4})\\)(.*?)(\\S*)$'
    entries <- data.frame(do.call(rbind, regmatches(entries, regexec(pattern, entries))),
                          stringsAsFactors = F)
    
    colnames(entries) <- c('entry', 'name', 'release.year', 'metadata', 'air.date')
    
    # Trim whitespace on metadata since above regex pattern isn't perfect.
    entries <- within(entries, metadata <- str_trim(metadata))
    
    # Remove entry column
    entries <- subset(entries, select = -entry)

    # Save the data.frame for faster access next time and close file connection.
    save(entries, file = 'entries.Rdata')
    close(connection)
  } else {
    load('entries.Rdata')
  }
  return(entries)
}

# There are 3,198,314 rows in entries.list.
infile <- 'movies.list.gz'
entries <- preprocessEntries(infile)

# Filter using heuristics to identify only movies.
# The order of the filters is very important as TV shows have
# entries that look like movies but are removed in the duplicate check
# Duplicates may not be found if they are eliminated for other criteria first.
getMovies <- function(entries) {
  # Assumption 1
  # Movie remakes would not occur within the same calendar year so we will
  # remove all name/year duplicates including first occurence. The duplicated()
  # function finds all entries that are the same and keeps the first one. We can
  # eliminate all duplicates if we also keep the last and then look for a True in
  # either implementation.
  filter1 <- (duplicated(entries[c('name', 'release.year')]) | 
              duplicated(entries[c('name', 'release.year')], fromLast = T))
  entries <- entries[!filter1,]

  # Assumption 2
  # TV series begins with a pound sign so eliminate them.
  filter2 <- with(entries, grepl('^#', name))
  entries <- entries[!filter2,]

  # Assumption 3
  # Movies must have an air date of a single year and not a range.
  filter3 <- with(entries, grepl('-', air.date))
  entries <- entries[!filter3,]

  # Assumption 4
  # Movies must have a known release.year to be verified.
  filter4 <- with(entries, grepl('..\\?\\?', release.year))
  entries <- entries[!filter4,]
  return(entries)
}

# Trim data.frame down to the only variables requested.
movies <- subset(getMovies(entries), select=c('name', 'release.year'))

# $ print(nrow(movies))
#   148382
# 
cat("There are", nrow(movies), "movies.\n\n")

# $ print(tail(head(movies, 10000)))
#             name      release.year
#   387278    Astero         1959
#   387279  Asteroid         1974
#   387280  Asteroid         1997
#   387281  Asteroid         2012
#   387282 Asteroide         2014
#   387283 Asteroids         1979
#
cat("Example of data:\n")
print(tail(head(movies, 10000)))
