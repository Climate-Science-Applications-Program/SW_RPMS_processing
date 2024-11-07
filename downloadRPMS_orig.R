# download RPMS data from fuelcast.net, save SW grids
# MAC 10/17/23

library(raster)

# set rasteroptions
rasterOptions(progress = 'text')

# Set the download timeout to 600 seconds
options(timeout = 600)

#showTmpFiles()
#removeTmpFiles()

# Start the clock!
ptm <- proc.time()

#yr<-2023

for(yr in 1984:1984){
  # link from https://fuelcast.net/downloads
  print("downloading file")
  download.file(paste0("https://fuelcast.net/rpms-download?date=",yr,"&file=rpms_",yr,".tif"),
                destfile = paste0("temp.tif"),extra = "--no-verbose")
  
  # load into layer
  rpms<-raster("temp.tif")
  print("cropping")
  rpms<-crop(rpms,extent(-114.982910,-102.864990,31.269161,37.072710))
  
  # save cropped raster
  #writeRaster(rpms, filename = "./rpms/test.grd", overwrite=TRUE)
  print("saving cropped tif")
  writeRaster(rpms, filename = paste0("/scratch/crimmins/USDA_NPP/v2023/swRPMS_",yr,".tif"), format="GTiff", overwrite=TRUE)
  
  print(yr)
  
  removeTmpFiles()
  
}

# Stop the clock
proc.time() - ptm

unlink("temp.tif")


