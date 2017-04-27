# Clint Valentine
# 01/23/2017
rm(list = ls())

# Create a date function that converts Date to the .csv format
setAs("character","acqDate", function(from) as.Date(from, format="%d/%M/%Y") )

acquisitions <- read.table("Acquisitions.csv",
                           header=T,
                           sep=",",
                           colClasses=c("acqDate", "character"))

leastInvInterval <- function(acquisitions) {
  # Computes the smallest successive time interval in acquisitions.
  #
  # Args:
  #   acquisitions: Acquisitions data.
  #
  # Returns:
  #   Smallest date difference of all successive entries.
  return(min(diff(acquisitions[,1], lag=1)))
}