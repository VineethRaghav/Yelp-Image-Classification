#library(devtools)
#library(magick)

#install('C:/Users/vineeth raghav/Downloads/Uconn/Sem 2/R/indicoio_0.3/indicoio')
#install.packages("C:/Users/vineeth raghav/Downloads/Uconn/Sem 2/R/indicoio_0.3/indicoio",repos=NULL, type="source")
#library(indicoio)
#--------------------------------------------------------------------------------------------------------------
#Download Inception_BN pretrained model from http://mxnet.io/tutorials/r/classifyRealImageWithPretrainedModel.html
install.packages("imager")
install.packages("drat", repos="https://cran.rstudio.com")
drat:::addRepo("dmlc")
install.packages("mxnet")


library(imager)
library(jpeg)
library(mxnet)
library(readr)
library(plyr)
#-------------------------------------------------------------------------------------------------------
# Converting to Grayscale

# imgPath <- "C:\\Users\\vineeth raghav\\Desktop\\10.jpg"
# imgvec<-readJPEG(imgPath, native = FALSE)
# #imgvec <- load.image(imgPath)
# cimgg = as.cimg(imgvec, x = dim(imgvec)[1], y = dim(imgvec)[2], z = 1, cc = 3)
# plot(cimgg)
# img1 <- grayscale(cimgg,method = "Luma", drop = TRUE)
# plot(img1, xlim = c(0,(dim(img1)[1])), ylim = c(0,(dim(img1)[2])))

# Reducing the scale

# img2 <- resize(img1, size_x = -25L, size_y = -25L, size_z = -25L, size_c = -25L)
# plot(img2, xlim = c(0,(dim(img1)[1])), ylim = c(0,(dim(img1)[2])))
# save.image(img2,"C:\\Users\\vineeth raghav\\Desktop\\10new.jpg",quality = 0.7)
#-------------------------------------------------------------------------------------------------------
#par(mfrow=c(1,2))
#plot(img2[1,])
#for (i in seq(2:dim(img2)[1]))
  #{
  #points(img2[i,])
  # }
#plot(img2)

#--------------------------------------------------------------------------------------------------------
# Using Mxnet
model = mx.model.load("C:/Users/vineeth raghav/Downloads/Uconn/R Proj/Inception/Inception_BN", iteration=39)
mean.img = as.array(mx.nd.load("C:/Users/vineeth raghav/Downloads/Uconn/R Proj/Inception/mean_224.nd")[["mean_img"]])
train_photo_to_biz_ids <- read.csv("C:/Users/vineeth raghav/Downloads/Uconn/R Proj/train_photo_to_biz_ids/train_photo_to_biz_ids.csv")
file = train_photo_to_biz_ids[train_photo_to_biz_ids$business_id==485,1]

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
feature = list()
for (i in 1:length(file))
{
  im <- load.image(paste("C:/Users/vineeth raghav/Downloads/Uconn/R Proj/train_photos/Processed_Images/485/",paste(file[i],".jpg",sep=""),sep=""))
  #im <- load.image("C:/Users/vineeth raghav/Downloads/Uconn/R Proj/train_photos/Processed_Images/485/46698.jpg")
  normed <- preproc.image(im, mean.img)
  prob <- predict(model, X=normed)
  #ifelse(length(prob)==1000,feature <- cbind(feature,prob),feature)
  feature <- cbind(feature,prob)
}
trans_feature <- t(feature)
# dim(prob)
# max.idx <- max.col(t(prob))
# max.idx
# synsets <- readLines("C:/Users/vineeth raghav/Downloads/Uconn/R Proj/Inception/synset.txt")
# print(paste0("Predicted Top-class: ", synsets  [[max.idx]]))



#---------------------------------------------------------------------------------------------------------
# reading features and images (Converting pics to business features)
business_feature <- rowMeans(apply(trans_feature,1,as.numeric),2,dims =1)


#-----------------------------------------------------------------------------------------------------------
#fpath <- system.file('C:/Users/vineeth raghav/Desktop/2.jpg',package='imager')
#parrots <- load.image('C:/Users/vineeth raghav/Desktop/2.jpg')



#imgDF<-as.data.frame(imgvec)
#img <- image_read(imgPath)
#img
#img1 <- grayscale(img,method = "XYZ", drop = TRUE)
#img<- image_scale(img,"x100")
#img
#image_write(img,"C:\\Users\\vineeth raghav\\Desktop\\2new.jpg",format = "jpeg")

#imgPath1 <- "C:\\Users\\vineeth raghav\\Desktop\\2new.jpg"
#imgvec<-readJPEG(imgPath1, native = FALSE)
#imgDF<-as.data.frame(imgvec)
#emo<-image_features(imgDF, local.api = FALSE)
#dim(img)
#devtools::install_github("dahtah/imager")


