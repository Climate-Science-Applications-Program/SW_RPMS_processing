# process RPMS data downloaded locally
# MAC 11/7/2024

library(terra)

# Set the download timeout to 600 seconds
options(timeout = 600)

# Load the raster into a SpatRaster object
rpms <- rast("./temp/rpms-max-ppa-ls-2024.tif")

# Crop the raster to the specified extent
print("cropping")
extent_crop <- ext(-114.982910, -102.864990, 31.269161, 37.072710)
rpms <- crop(rpms, extent_crop)

# Save the cropped raster as a GeoTIFF
print("saving cropped tif")
yr<-2024
writeRaster(rpms, filename = paste0("./swRPMS_data/swRPMS_", yr, ".tif"), filetype = "GTiff", overwrite = TRUE)

