#library(devtools)
#library(magick)

#install('C:/Users/vineeth raghav/Downloads/Uconn/Sem 2/R/indicoio_0.3/indicoio')
#install.packages("C:/Users/vineeth raghav/Downloads/Uconn/Sem 2/R/indicoio_0.3/indicoio",repos=NULL, type="source")
#library(indicoio)
#--------------------------------------------------------------------------------------------------------------
#Download Inception_BN pretrained model from http://mxnet.io/tutorials/r/classifyRealImageWithPretrainedModel.html
library(devtools)

install.packages("imager")

install.packages("drat", repos="https://cran.rstudio.com")
drat:::addRepo("dmlc")
install.packages("visNetwork", repos="https://cran.rstudio.com")

install.packages("mxnet")


library(imager)
library(mxnet)
library(readr)
library(plyr)
#-------------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------------
# Using Mxnet
model = mx.model.load("C:/Users/vineeth raghav/Downloads/Uconn/R Proj/Inception/Inception_BN", iteration=39)
mean.img = as.array(mx.nd.load("C:/Users/vineeth raghav/Downloads/Uconn/R Proj/Inception/mean_224.nd")[["mean_img"]])
train_photo_to_biz_ids <- read.csv("C:/Users/vineeth raghav/Downloads/Uconn/R Proj/train_photo_to_biz_ids/train_photo_to_biz_ids.csv")
source_path = "C:/Users/vineeth raghav/Downloads/Uconn/R Proj/train_photos/Processed_Images/"

myrange = 401:500

preproc.image <- function(im, mean.image) 
  {
  # crop the image
  shape <- dim(im)
  short.edge <- min(shape[1:2])
  xx <- floor((shape[1] - short.edge) / 2)
  yy <- floor((shape[2] - short.edge) / 2)
  cropped <- crop.borders(im, xx, yy)
  # resize to 224 x 224, needed by input of the model.
  resized <- resize(cropped, 224, 224)
  # convert to array (x, y, channel)
  arr <- as.array(resized) * 255
  dim(arr) <- c(224, 224, 3)
  # subtract the mean
  normed <- arr - mean.img
  # Reshape to format needed by mxnet (width, height, channel, num)
  dim(normed) <- c(224, 224, 3, 1)
  return(normed)
}


## GETTING THE LIST OF DIRECTORY
files    <- list.files(path = source_path, full.names = TRUE, recursive = FALSE)
final_file = c()
for (f in files)
{
  if(as.numeric(basename(f)) %in% myrange)
  {
    final_file = c(final_file,f)  
  }
}

###################
#Finding the features for each photo and aggregating at business level

business_feature <- list()
business_name <- list()
for (i in final_file)
{
  business_name = rbind(business_name,basename(i))
  files    <- list.files(path = i, full.names = TRUE, recursive = TRUE)
  feature = list()
  for (file in files)
  {
    im <- load.image(file)
    normed <- preproc.image(im, mean.img)
    prob <- predict(model, X=normed)
    feature <- cbind(feature,prob)
  }
  trans_feature <- t(feature)
  mean_feature <- rowMeans(apply(trans_feaeture,1,as.numeric),2,dims =1)
  business_feature <- rbind(business_feature,mean_feature)
}
business_feature <- cbind(business_name,business_feature)
colnames(business_feature) <- 1:1001
colnames(business_feature)[1] <- "Business Name" 
colnames(business_feature)[-1] <- 1:1000
write.csv(business_feature,"C:/Users/vineeth raghav/Downloads/Uconn/R Proj/401-500_features.csv")
#-----------------------------------------------------------------------------------------------------------------------------
