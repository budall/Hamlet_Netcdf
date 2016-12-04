
rm(list = ls())
  

top_level <- "/Users/bradleyudall/Desktop/Gridded_Data/Hamlet/UCLA_1915_2015"

dirs <- list.files(top_level, pattern="[1-9]{4}")

for (i in 1:length(dirs)) {

  new_dir <-
    paste("/Users/bradleyudall/Desktop/Gridded_Data/Hamlet/UCLA_1915_2015/",
          dirs[i],
          sep = "")
  
  print(new_dir)
  
  setwd(new_dir)
  
  all_files <- list.files()
  
  mymergeddata <-
    do.call(rbind,
            lapply(all_files, read.csv))
  
  
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