library(twitteR)
library(ROAuth)
library(RCurl)

requestURL <- "https://api.twitter.com/oauth/request_token"
accessURL <- "https://api.twitter.com/oauth/access_token"
authURL <- "https://api.twitter.com/oauth/authorize"
APIkey <- "jZ2ZCev4xiVMVDBjwh2daV9jm"
APIsecret <- "ELESnpu0u1v8WVhffsqkrLELlYcaZJmQoroiYF6SEgiC93yf1n"
Accesstoken <- "223871290-npPvRX73aiK6DrSHoXSmHkzTgy1FOiBpofBC4ru5"
Accesssecret <- "3fIU2raElfxYu03aUFq98MBvBoLVw6xwomx9CjlAuogJh"

twitCred<-setup_twitter_oauth(APIkey,APIsecret,Accesstoken,Accesssecret)

