# Clint Valentine
# 01/21/2017
rm(list = ls())

# If the data.frame already exists then do not load again
if (!exists("data")) {
  # Unzip data and process as csv with a header
  unzip("AirlineDelays.zip")
  data <- read.table("AirlineDelays.txt", header=T, sep=",")
}

TotalNumDelays <- function(Carrier) {
  # Computes the total number of unique delays for each carrier.
  #
  # Args:
  #   Carrier: Airline carrier in data.
  #
  # Returns:
  #   The total number of unique delays.
  selection <- subset(data, CARRIER == Carrier)
  
  # All delay types are in 6:7 and 9:13, sum them up as unique
  count <- sum(apply(selection[,c(6:7,9:13)],
                     MARGIN=2, 
                     function(x) sum(x > 0, na.rm=T)))
  return(count)
}

TotalDelaysByOrigin <- function(Origin) {
  # Computes the total number of unique delays for each origin.
  #
  # Origin:
  #   Origin: Origin of flight in data.
  #
  # Returns:
  #   The total number of unique delays.
  selection <- subset(data, ORIGIN == Origin)
  
  # All delay types are in 6:7 and 9:13, sum them up as unique.
    count <- sum(apply(selection[,c(6:7,9:13)],
                     MARGIN=2, 
                     function(x) sum(x > 0, na.rm=T)))
  return(count)
}

AvgDelay <- function(Carrier, Dest) {
  # Computes the average delay in minutes for a specified carrier
  # and destination in data.
  #
  # Origin:
  #   Carrier: Airline carrier in data.
  #   Dest: Destination of flight in data.
  #
  # Returns:
  #   The average delay in minutes.
  selection <- subset(data, CARRIER == Carrier & DEST == Dest)
  
  return(unname(sapply(selection['ARR_DELAY'], mean, na.rm=T)))
}