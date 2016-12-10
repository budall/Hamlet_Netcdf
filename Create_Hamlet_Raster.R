
# read in one big file...

rm(list = ls())
  

top_level <- "/Users/bradleyudall/Desktop/Gridded_Data/Hamlet/UCLA_1915_2015/"

dirs <- list.files(top_level, pattern="[1-9]{4}")
#dirs <- list.files(top_level)

for (i in 1:length(dirs)) {

  i=3
  new_dir <-
    paste("/Users/bradleyudall/Desktop/Gridded_Data/Hamlet/UCLA_1915_2015/",
          dirs[i],"/textfiles", dirs[i],
          sep = "")
  
  print(new_dir)
  
  setwd(new_dir)
  
  all_files <- list.files()
  
  # better than below, just make one file using shell script? or Extract_Hamlet_Data
  # $awk 'FNR > 1 { print }' *.csv USE THIS to concatenate, not the lines below
  # issue a system call to do a cat * to one file??
  
  mymergeddata <-
    do.call(rbind,
            lapply(all_files, read.csv))
  
  mymergeddata <-
    do.call(rbind,
            lapply(dirs, read.csv))
  
  
  
  # at this point we have a big dataframe for the entire year, each row is a month for a given lat/long pair
  # we are going to wirte out 4 files, each for one variable (), each for one complete year
  # subset the data frame by variable and by month
  # create a raster for that month
  # stack the raster by month
  # write out the entire 12 months...
  
  for (month in 1:12) {
    month =1
    new_data <- mymergeddata[mymergeddata$X==month, c(mymergeddata$lat, mymergeddata$long)]
  }
  
  
  
  
  
  
  
  
  # might make more sense just to cat these files together, then read in all at once.
  
  
  
  # need to make the raster here...
  
  # need to create bands based on dates
  
  # do we create 1 raster per month, or can we have an annual file with bot multiple dates and multiple fields?
  
  # might just need to do annual file for each variable..with 12 bands, one per month
  # so hamlet_tmin_1915_1.nc
  # etc...that is the PRISM model
  
  library(raster)
  test <- rasterFromXYZ(mymergeddata)
  plot(test)
  
 # https://gis.stackexchange.com/questions/20018/how-can-i-convert-data-in-the-form-of-lat-lon-value-into-a-raster-file-using-r
  
   library(sp)
   library(rgdal)
   coordinates(pts)=~x+y
   proj4string(pts)=CRS("+init=epsg:4326") # set it to lat-long
   pts = spTransform(pts,CRS("insert your proj4 string here"))
  
   # d. Tell R that this is gridded:
  #   
     gridded(pts) = TRUE
  # At this point you'll get an error if your coordinates don't lie on a nice regular grid.
  # Now use the raster package to convert to a raster and set its CRS:
     r = raster(pts)
   projection(r) = CRS("insert your proj4 string here")
  # Now have a look:
     plot(r)
  # Now write it as a geoTIFF file using the raster package:
     writeRaster(r,"pts.tif")
  
}