# Clint Valentine
# 01/25/2017

rm(list = ls())

require(XML)

# Could not load from URL as the URL was down so I loaded in locally
senators <- xmlToDataFrame('senators.xml')

senatorName <- function(st, data) {
  # Returns the senators of a given state abbreviation.
  #
  # Args:
  #   st: Capitalized state abbreviation.
  #
  # Returns:
  #   Full names of senators in state.
  return(with(data, paste(first_name[state == st],
                          last_name[state == st]))) 
}

senatorPhone <- function(first, last, data) {
  # Returns the phone number of a given senator.
  #
  # Args:
  #   first: First name of senator.
  #   last: Last name of senator.
  #
  # Returns:
  #   Phone number of a given senator.
  
  # Split first_name on spaces and only take first argument
  first.names <- sapply(with(data, strsplit(first_name, ' ')),
                        function(x) x[[1]])
  
  return(with(data, phone[first.names == first & last_name ==last]))
}

# Test the functions work on known inputs
print(senatorName("MA", data = senators))
print(senatorPhone("John", "Kerry", data = senators))