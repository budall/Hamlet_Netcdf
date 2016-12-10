rm(list = ls())

library(raster)
library(rgdal)
library(timeSeries)
library(zoo)
library(xts)

rm(list = ls())

start <- Sys.time()

top_level <-
  "/Users/bradleyudall/Desktop/Gridded_Data/Hamlet/UCLA_1915_2015/"

var_types <- c("precip", "wind", "tmin", "tmax")

startYr <- 1915
endYr <- 1916

for (yr in startYr:endYr) {
  for (var_kind in 1:length(var_types)) {
    stub <-
      "/Users/bradleyudall/Desktop/Gridded_Data/Hamlet/UCLA_1915_2015"
    # break this into a subdir based on the variable? to keep files manageable?
    file_dir <- paste(stub, "/", yr,  "/", sep = "")
    input_filename  = paste(file_dir, yr, "_", var_types[var_kind], ".csv", sep = "")
    output_filename = paste(file_dir, yr, "_", var_types[var_kind], ".nc",  sep = "")
    data_file <- read.csv(file = input_filename, header = False)
    colnames(data_file) <- c("month", "dates", "lat", "long", "var")
    master_stack <- raster()
    for (month in 1:12) {
      data_to_raster[data_to_raster$month == month,]
      new_layer <- rasterFromXYZ(data_to_raster)
      master_stack <- stack(new_layer, band = month)
    }
    writeRaster(file=output_filename, master_stack)
 }
  
}  
  

  
  plot(test)
  
  
  
  # https://gis.stackexchange.com/questions/20018/how-can-i-convert-data-in-the-form-of-lat-lon-value-into-a-raster-file-using-r
  
  library(sp)
  library(rgdal)
  coordinates(pts) =  ~ x + y
  proj4string(pts) = CRS("+init=epsg:4326") # set it to lat-long
  pts = spTransform(pts, CRS("insert your proj4 string here"))
  
  # d. Tell R that this is gridded:
  #
  #    gridded(pts) = TRUE
  # At this point you'll get an error if your coordinates don't lie on a nice regular grid.
  # Now use the raster package to convert to a raster and set its CRS:
  #   r = raster(pts)
  # projection(r) = CRS("insert your proj4 string here")
  # Now have a look:
  #   plot(r)
  # Now write it as a geoTIFF file using the raster package:
  #   writeRaster(r,"pts.tif")
  
}