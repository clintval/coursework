##########################################################################################
##  Collecting Twitter Data from Streaming API
##
## Sample intro course material. Demonstrates how to collect some basic data from Twitter 
## (though streaming API).
##
## To run this script, you need to generate your own "consumerKey", "consumerSecret", and 
## an oAuth token by ##registering your application with Twitter. It is a simple process, 
## just pick a name for your application. ##Register it here: https://dev.twitter.com/apps 
##
## Documentation of Twitter Streaming API:
##   https://dev.twitter.com/docs/streaming-apis/streams/public
##   https://dev.twitter.com/docs/auth/authorizing-request
##   http://www.foundations-edge.com/blog/oauth_in_R.html
##   https://dev.twitter.com/docs/streaming-apis/processing
##
## Prepared by Christoph Riedl
##      D'Amore-McKim School of Business & 
##          College of Computer and Information Science
##
##      email: c.riedl@neu.edu 
##      web: http://www.christophriedl.net
## Modified by Brinal Pereira
##    College of Computer and Information Science
##    
##    email: pereira.b@husky.neu.edu
##    Kathleen Durant 
##  Add the new ROAuth package to the code 
##########################################################################################

## Change working directory
setwd("C:/Users/kath/Desktop")
# Load required libraries                                                                                          
library(RCurl)
library(ROAuth)
library(streamR)
library(twitteR)
library(ROAuth)


#download certificate needed for authentication, creates a certificate file on desktop
download.file(url="http://curl.haxx.se/ca/cacert.pem", destfile="cacert.pem")

# Configuration for twitter
#create a file to collect all the Twitter JSON data recevied from the API call
outFile <- "tweets_sample.json"
# Twitter configuration
# Set all the Configuration details to authorize your application to access Twitter data.
requestURL        <- "https://api.twitter.com/oauth/request_token"
accessURL         <- "https://api.twitter.com/oauth/access_token"
authURL           <- "https://api.twitter.com/oauth/authorize"
consumerKey       <- "FILLINYOURVALUE"
consumerSecret    <- "FILLINYOURVALUE"
accessToken       <- "FILLINYOURVALUE"
accessTokenSecret <- "FILLINYOURVALUE"


#obtain oauth by handshaking and save the oauth to the local disk for future connections
my_oauth <- OAuthFactory$new( consumerKey=consumerKey,
                              consumerSecret=consumerSecret,
                              requestURL=requestURL,
                              accessURL=accessURL, 
                              authURL=authURL)
# returns the oauth 
my_oauth$handshake(cainfo="cacert.pem")

##########################################################################################
## PAUSE HERE !!!!!
## Once executing the above code returns true, you will be given a link to authorize your 
## application to get twitter feeds. Copy the link in your browser. Click on "Authorize 
## MyApplication." You will receive a pin number. Copy the pin number and paste it in the 
## console. Once your application has been authorized you need to register your credentials.                                  
##########################################################################################

# set up the OAuth credentials for a twitterR session 
setup_twitter_oauth(consumerKey, consumerSecret, accessToken, accessTokenSecret)

# Press 1 in the console to allow the file to access the credentials 


##Now start reading tweets
# sampleStream opens a connection to Twitter’s Streaming API that will return a random 
# sample of public statuses.
sampleStream( file=outFile, oauth=my_oauth, tweets=100 )

##Alternative: a little more advanced if you want to filter for things
# TwitterIDs (not screennames!) of people to follow
follow   <- ""  
# Comma-separated list of words to filter
track    <- "Boston,RedSoxs"  
# Geolocation of tweets to filter for (see documentation)
location <- c(23.786699, 60.878590, 37.097000, 77.840813)  
# This creates a file on the desktop tweets_sample.json in which the tweet data will be stored.                      
filterStream( file.name=outFile, follow=follow, track=track, locations=location, 
              oauth=my_oauth, timeout=5)

## References :                                                                                                  
## * http://tryr.codeschool.com                                                                            
## * https://dev.twitter.com/oauth/pin-based                                              
