# Clint Valentine
# 01/23/2017
#rm(list = ls())

library(DescTools)
require(lubridate)
library(stringr)

# DescTools::XLGetRange is the only way I could import Excel format
# Be aware this may take approximately 5 minutes on an i7 processor
# Note: DescTools seems to require only an absolute path
if ( exists('market.geo') == F ) {
  
  if ( file.exists('market.geo.Rdata') == F ) {
    market.geo <- XLGetRange(
      as.data.frame = T,
      file = 'C:\\dev\\coursework\\data_collecting_storing_retrieving\\module04\\2013 Geographric Coordinate Spreadsheet for U S  Farmers Markets 8\'3\'1013.xlsx',
      header = T,
      range = c('A3:AS8417'),
      sheet = 'Export'
    )
    save(market.geo, file = 'market.geo.Rdata')
  }
  
  else {
    load('market.geo.Rdata')
  }
  
}

# Keep only valid date ranges, set the rest to NA
#market.geo <- within(market.geo,
#                     Season1Date <- str_match(Season1Date, '.*to.*'))

# For debugging
valid.dates.ix <- !is.na(market.geo$Season1Date)

standardizeSeason <- function(x) {
  pattern <- '([a-zA-Z0-9/ ]+)\\sto\\s([a-zA-Z0-9/ ]+)'
  start.stop <- str_match_all(x, pattern)[[1]][,2:3]
  
  if ( any(is.na(start.stop)) == T ) {
    return(NA)
  }
  
  start <- start.stop[1]
  stop <- start.stop[2]
  
  if ( str_detect(paste(start, stop, collapse=''), ',' ) == T |
       str_detect(paste(start, stop, collapse=''), '/') == T )  {
    day.span <- days(mdy(stop) - mdy(start))
    print(day.span)
  }
  else {
    start <- strptime(paste(start, "1", sep=""), "%B %d")
    stop <- strptime(paste(stop, "1", sep=""), 
    day.span <- difftime(
      ,
      strptime(paste(start, "1", sep=""), "%B %d")
      )
    print(day.span)
    print("****")
  }
  

  #return(start.stop)
}

lapply(market.geo$Season1Date, standardizeSeason)