# Process RPMS data to get period average and recent year anomaly
# use downloadRPMS.R to add new years
# MAC 10/19/23

library(terra)

# Load files into SpatRaster collection
file_list <- list.files(path="./swRPMS_data", pattern=".tif", full.names=TRUE, recursive=FALSE)

# get range of years
yrs <- as.numeric(gsub(".*_(\\d{4})\\.tif$", "\\1", file_list))

# Drop 2012 from list, bad data?
file_list <- file_list[-29]
# Leave out most recent year
rpmsStack <- rast(file_list[1:(length(file_list) - 1)])
#rpmsStack <- rast(file_list[1:(length(file_list))])


# Calculate mean
meanRPMS <- app(rpmsStack, fun = mean, na.rm = TRUE)

# Check data
plot(meanRPMS)

# Write out long-term mean
writeRaster(meanRPMS, filename = paste0("./swRPMS_processed/swRPMS_",min(yrs),"_",max(yrs-1),"mean.tif"), filetype ="GTiff", overwrite=TRUE)

# Calculate anomaly of most recent year
currYrRaster <- rast(file_list[length(file_list)])
# Load mean if needed
meanRPMS <- rast(paste0("./swRPMS_processed/swRPMS_",min(yrs),"_",max(yrs-1),"mean.tif"))

#rpmsAnom <- currYrRaster - meanRPMS
#writeRaster(rpmsAnom, filename = "./swRPMS_processed/swRPMS_2023anom.tif", format="GTiff", overwrite=TRUE)

# Percent of average
rpmsPerc <- (currYrRaster / meanRPMS) * 100
plot(rpmsPerc)
# get curryear for file name
currYr <- as.numeric(gsub(".*_(\\d{4})\\.tif$", "\\1", file_list[length(file_list)]))

# write to file
writeRaster(rpmsPerc, filename = paste0("./swRPMS_processed/swRPMS_",currYr,"perc.tif"), filetype ="GTiff", overwrite=TRUE)

# upload to https://cales.arizona.edu/climate/misc/SWrpms/
# run https://github.com/Climate-Science-Applications-Program/Micro_Apps/blob/main/Scripts/mapRPMS.R

