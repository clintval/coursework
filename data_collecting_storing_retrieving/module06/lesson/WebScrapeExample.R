##############################################################
##  CS6020 - Lesson 6: Data Collection Through Web Scraping
##
##  Collecting unavailable data from the City of Boston 
##  Assessor's office website
##
##  Demonstrates how to build an ad hoc web scraper in R
##
## 
##  Documentation of Webscraping in R:
##   http://cran.r-project.org/web/packages
##   http://www.w3schools.com/xpath/xpath_intro.asp
##
##
##  Prepared by Brinal Pereira with Modification by
##  Martin Schedlbauer, Northeastern University
##  College of Computer and Information Science
##    
##############################################################

# Load the required libraries
library(RCurl)
library(XML)

#Set the working directory to your workspace
setwd("C:/dev/coursework/data_collecting_storing_retrieving/module05/lesson")

# This is the URL of the website we need scrape to get information on the 
# total assessed value of Northeastern University's properties
theurl <- "http://www.cityofboston.gov/assessing/search/?pid=0402236000"
webpage <- getURL(theurl)
# convert the page into a line-by-line format rather than a single string
tc <- textConnection(webpage)
webpage <- readLines(tc) 
close(tc)


pagetree <- htmlTreeParse(webpage, useInternalNodes = TRUE)

parcelID <- unlist(xpathApply(pagetree,"//*/table[@width='100%'][@cellpadding='0']/tr[3]/td",xmlValue))
parcelID

ownerName <- unlist(xpathApply(pagetree,"//*/table[@width='100%'][@cellpadding='0']/tr[9]/td",xmlValue))
ownerName

totalValueLabel <- unlist(xpathApply(pagetree,"//*/table[@width='100%']/tr[5]/td/b",xmlValue))
print(totalValueLabel)
ttLabel<- unlist(strsplit(totalValueLabel, ":"))
ttLabel[2]

totalValueText <- unlist(xpathApply(pagetree,"//*/table[@width='100%']/tr[5]/td[@align = 'right']",xmlValue))
ttText <- unlist(strsplit(totalValueText, " "))
ttText <- gsub(pattern = "([\t\n])",
                   replacement ="" , x = ttText[2], ignore.case = TRUE,
                   perl = FALSE, fixed = FALSE, useBytes = FALSE)
ttText

x <- unlist(xpathApply(pagetree, "//*/table[@width='100%']/tr[2]/th[@align='center']", xmlValue))
y <- unlist(xpathApply(pagetree, "//*/table[@width='100%']/tr/td[@align='center']", xmlValue))
content <- as.data.frame(matrix(y, ncol = 3, byrow = TRUE))
new.line.3 <- gsub(pattern = "([\t\n])",
                   replacement ="" , x = x, ignore.case = TRUE,
                   perl = FALSE, fixed = FALSE, useBytes = FALSE)
new.line.3
content

