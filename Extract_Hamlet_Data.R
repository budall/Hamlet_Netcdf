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

setwd <-
  "/Users/bradleyudall/Desktop/Gridded_Data/Hamlet/UCLA_1915_2015"
filestub <-
  "/Users/bradleyudall/Desktop/Gridded_Data/Hamlet/UCLA_1915_2015/"

setwd <-
  "/Users/bradleyudall/Desktop/Gridded_Data/Hamlet/UCLA_1915_2015/raw"
file_list <-
  list.files(path = "/Users/bradleyudall/Desktop/Gridded_Data/Hamlet/UCLA_1915_2015/raw")			#  first in list will be root (".")

start <- Sys.time()




for (i in 1:length(file_list))  {
#  for (i in 1:10)  {
  # print(file_list[i])
 # i=1
  filestub <-
    "/Users/bradleyudall/Desktop/Gridded_Data/Hamlet/UCLA_1915_2015/raw/"
  file_next <- paste(filestub, file_list[i[]], sep = "")
  print(file_next)
  print(i)
  
  #filestub <- "/Users/bradleyudall/Desktop/Gridded_Data/Hamlet/UCLA_1915_2015/raw/data_40.34375_-123.15625"
  filestub <- file_next
  
  teststr <- as.vector(strsplit(filestub, "_"))
  
  lat <- as.numeric(teststr[[1]][5])
  long <- as.numeric(teststr[[1]][6])
  print(lat)
  print(long)
  
   if ( ( (lat >= 30) & (lat <= 44)) & ( (long <= -104)  & (long >= -116) ) ) {
     print("in bounds")
#     next() for testing
}
   else {
    print("skipping")
       next()
 }

    
  netcdf_filename <- filestub
  
  xyz_file <- read.table(netcdf_filename)
  colnames(xyz_file) [1:4] <- c("precip", "tmax", "tmin", "wind")
  
  # make time series, although don't know if i use...I USE the LAST ONe
  data.ts    <- ts(xyz_file,   start = c(1915, 1, 1),  frequency = 365)
  
  dates_daily <-
    seq(as.Date('1915-01-01'),
        by = 'day',
        to = as.Date('2014-12-31'))
  dates_mon <-
    seq(as.Date('1915-01-01'),
        by = 'mon',
        to = as.Date('2014-12-31'))
  
  precip <- xyz_file$precip
  precip.df <- data.frame(dates_daily, precip)
  precip.xts <-
    xts(precip.df[,-1], order.by = as.Date(precip.df$dates_daily))
  precip_mon <- apply.monthly(precip.xts, apply, 2, sum)
  
  wind <- xyz_file$wind
  wind.df <- data.frame(dates_daily, wind)
  wind.xts <-
    xts(wind.df[,-1], order.by = as.Date(wind.df$dates_daily))
  wind_mon <- apply.monthly(wind.xts, apply, 2, mean)
  
  tmin <- xyz_file$tmin
  tmin.df <- data.frame(dates_daily, tmin)
  tmin.xts <-
    xts(tmin.df[,-1], order.by = as.Date(tmin.df$dates_daily))
  # NOTE BUG HERE? mean.date? Changed to mean...
  tmin_mon <- apply.monthly(tmin.xts, apply, 2, mean.Date)
  tmin_mon <- apply.monthly(tmin.xts, apply, 2, mean)
  
  tmax <- xyz_file$tmax
  tmax.df <- data.frame(dates_daily, tmax)
  tmax.xts <-
    xts(tmax.df[,-1], order.by = as.Date(tmax.df$dates_daily))
  tmax_mon <- apply.monthly(tmax.xts, apply, 2, mean)
  
  # I think I need to separate this out by variable and create 4 file types...
  all_variables <-
    data.frame(dates_mon, lat, long, precip_mon, wind_mon, tmin_mon, tmax_mon)
  
  all.xts <-
    xts(all_variables, order.by = as.Date(all_variables$dates_mon))
  # above works, now do for wind, tmax, tmin
  
  # rejoin into one monthly data frame
  
  # write out into separate year files
  
  var_types <- c("precip", "wind", "tmin", "tmax")
  
  startYr <- 1915
  endYr <- 2015
  for (yr in startYr:endYr) {
    for (var_kind in 1:length(var_types)) {
      stub <- "/Users/bradleyudall/Desktop/Gridded_Data/Hamlet/UCLA_1915_2015"
      # break this into a subdir based on the variable? to keep files manageable?
      file_dir <- paste(stub, "/", yr,  "/", yr, sep = "")
      filename = paste(file_dir, "_A_", var_types[var_kind], ".csv", sep = "")
      
      print(filename)
      
      # need to subset date, lat, long, variable
    #  subpart <- all.xts[as.character(yr), XXX == var_kind]
        subpart <- all.xts[as.character(yr)]
        subpart <- subpart[,c(1:3,(var_kind+3)) ]
      
      # modidfy this to not write out the header....
      # also, think about just writing one file per year...maybe this is too much trouble
      append_to_file <- TRUE
      if (i == 1) {
        append_to_file <- FALSE
      }
      write.table(file = filename,
                col.names = FALSE,
                append = append_to_file,
                sep = ",",
                subpart)
      
    }
  }
  
}

print("DONE")
print(start)
Sys.time()
