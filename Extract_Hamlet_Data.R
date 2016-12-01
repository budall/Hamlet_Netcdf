# create an array of avg temps by year, month just for the Upper Colorado River Basin (UCB)
# use the mean temp file...don't have to average temperatures.

# works for all 3 variables, ESRL datasets of Livneh data

rm(list = ls())

library(raster)
library(rgdal)
library(timeSeries)
library(zoo)
library(xts)

rm(list = ls())

setwd <- "/Users/bradleyudall/Desktop/Gridded_Data/Hamlet/UCLA_1915_2015"
filestub <- "/Users/bradleyudall/Desktop/Gridded_Data/Hamlet/UCLA_1915_2015/"

setwd <- "/Users/bradleyudall/Desktop/Gridded_Data/Hamlet/UCLA_1915_2015/adj.all"
file_list <- list.files(path="/Users/bradleyudall/Desktop/Gridded_Data/Hamlet/UCLA_1915_2015/adj.all")			#  first in list will be root (".")

start<-Sys.time()

for(i in 2:100 )  {
  print(file_list[i])
  
  filestub <- "/Users/bradleyudall/Desktop/Gridded_Data/Hamlet/UCLA_1915_2015/adj.all/"
  file_next <- paste(filestub, file_list[i[]], sep="")
 print(file_next)


#filestub <- "/Users/bradleyudall/Desktop/Gridded_Data/Hamlet/UCLA_1915_2015/adj.all/data_40.34375_-123.15625"
filestub <- file_next

teststr <-as.vector(strsplit(filestub, "_"))

lat <- teststr[[1]][5]
long <- teststr[[1]][6]

if ((lat >32) || (lat <40)) {
  break
}
if ((long < -111) || (long > -107)) {
  break
}

netcdf_filename <- filestub

xyz_file <- read.table(netcdf_filename)
colnames(xyz_file) [1:4] <- c("precip","tmax", "tmin", "wind")

# make time series, although don't know if i use...I USE the LAST ONe
data.ts    <- ts(xyz_file,   start=c(1915,1,1),  frequency=365)

dates_daily <-seq(as.Date('1915-01-01'), by='day', to=as.Date('2014-12-31'))
dates_mon <-seq(as.Date('1915-01-01'), by='mon', to=as.Date('2014-12-31'))

precip <- xyz_file$precip
precip.df <- data.frame(dates_daily, precip)
precip.xts <- xts(precip.df[, -1], order.by=as.Date(precip.df$dates_daily))
precip_mon <- apply.monthly(precip.xts, apply, 2, sum)

wind <- xyz_file$wind
wind.df <- data.frame(dates_daily, wind)
wind.xts <- xts(wind.df[, -1], order.by=as.Date(wind.df$dates_daily))
wind_mon <- apply.monthly(wind.xts, apply, 2, mean)

tmin <- xyz_file$tmin
tmin.df <- data.frame(dates_daily, tmin)
tmin.xts <- xts(tmin.df[, -1], order.by=as.Date(tmin.df$dates_daily))
tmin_mon <- apply.monthly(tmin.xts, apply, 2, mean.Date)

tmax <- xyz_file$tmax
tmax.df <- data.frame(dates_daily, tmax)
tmax.xts <- xts(tmax.df[, -1], order.by=as.Date(tmax.df$dates_daily))
tmax_mon <- apply.monthly(tmax.xts, apply, 2, mean)

all_variables <- data.frame(dates_mon, lat, long, precip_mon, wind_mon, tmin_mon, tmax_mon)

all.xts <- xts(all_variables, order.by=as.Date(all_variables$dates_mon))
# above works, now do for wind, tmax, tmin

# rejoin into one monthly data frame

# write out into separate year files

startYr <- 1915
endYr <- 2015
for(yr in startYr:endYr) {
  
  stub <- "/Users/bradleyudall/Desktop/Gridded_Data/Hamlet/UCLA_1915_2015"
  file_dir <- paste(stub, "/", yr, sep="")
  filename = paste(file_dir, "/_",lat,"_",long, ".csv", sep="")
  print(filename)
  subpart <- all.xts[as.character(yr)]
  write.csv(file=filename, subpart)  
 

}

}

print("DONE")
print(start)
Sys.time()
