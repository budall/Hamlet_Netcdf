

setwd <- "/Users/bradleyudall/Desktop/Gridded_Data/Hamlet/UCLA_1915_2015"

stub <- "/Users/bradleyudall/Desktop/Gridded_Data/Hamlet/UCLA_1915_2015"

startYr <- 1915
endYr <- 2015
for(yr in startYr:endYr) {
  
  file_dir <- paste(stub, "/", yr, sep="")
 
  print(file_dir)
  if (dir.exists(file_dir) == FALSE ) {
    dir.create(file_dir)
  }
}
  