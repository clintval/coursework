# Clint Valentine
# 01/25/2017

#rm(list = ls())

require(lubridate)
require(stringr)
require(XML)

if ( exists('root') == F ) {
  xmlObj <- xmlTreeParse('http://www.cs.washington.edu/research/xmldatasets/data/auctions/ebay.xml')
  root <- xmlRoot(xmlObj)
}

moreFiveBids <- function(data) {
  # Return the number of auctions with more than five bids.
  #
  # Args:
  #   data: xmlRoot object of Ebay auction data.
  #
  # Returns:
  #   Number of auctions with more than five bids.
  
  # XML data structure is hardcoded into this function
  num.bids <- as.numeric(sapply(root, function(x) xmlValue(x[[5]][[5]])))
  return(sum(num.bids > 5))
}

if (exists('trades') == F ) {
  trades <- xmlToDataFrame(
    doc = 'http://www.barchartmarketdata.com/data-samples/getHistory15.xml',
    collectNames = T
  )
  
  # Remove XML rows and columns due to code and message
  trades <- trades[-1, !names(trades) %in% c("code", "message")]
}

highestClosingPrice <- function(data) {
  # Returns highest closing price of stock data.
  #
  # Args:
  #   data: Stock data.
  #
  # Returns:
  #   Highest closing price.
  return(with(data, max(as.numeric(close), na.rm = T)))
}

totalVolume <- function(data) {
  # Returns total volume of stock data.
  #
  # Args:
  #   data: Stock data.
  #
  # Returns:
  #   Total volume.
  return(with(data, sum(as.numeric(volume), na.rm = T)))
}

averageVolume <- function(data) {
  # Returns average volume per hour in stock data.
  #
  # Args:
  #   data: Stock data.
  #
  # Returns:
  #   data.frame of average volume per hour.
  
  # Split the timestamp so first argument is day and second is time interval
  timestamp.split <- sapply(with(data, strsplit(timestamp, 'T')), function(x) x[[2]])
  
  # Split time interval on hyphen and store in named data.frame
  time.deltas <- data.frame(str_split_fixed(timestamp.split, '-', 2))
  colnames(time.deltas) <- c("start", "stop")

  # Parse all time objects in-place and make hours 1AM-based
  time.deltas <- within(time.deltas, hour <- 1 + hour(hms(start)))

  # Bind hours to data
  data <- cbind(data, hour = with(time.deltas, hour))
  
  # Aggregate average volume by hour and relable tally data.frame
  tally <- aggregate(as.numeric(data$volume),
                     by = list(hour = with(data, hour)),
                     FUN = mean)
  colnames(tally) <- c("Hour", "Average Trading Volume")
  return(tally)
  
}

# Solutions to HW problems
cat("Auctions with more than five bids:", moreFiveBids(root), "\n\n")

cat("Highest closing price:", highestClosingPrice(trades), "\n")
cat("Total volume traded:", totalVolume(trades), "\n")
cat("Average volume traded each hour:\n")
print(averageVolume(trades))
