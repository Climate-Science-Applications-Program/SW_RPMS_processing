# Process RPMS data to get period average and recent year anom
# use downloadRPMS.R to add new years
# MAC 10/19/23

library(raster)

# set rasteroptions
rasterOptions(progress = 'text')

#showTmpFiles()
#removeTmpFiles()

# load files into stack
file_list = list.files(path="/scratch/crimmins/USDA_NPP/v2023",pattern = ".tif", full.names = T, recursive = F)

# drop 2012 from list, bad data? 
file_list<-file_list[-29]
# leave out most recent year  
rpmsStack<-stack(file_list[1:(length(file_list)-1)])

# calculate mean
meanRPMS <- calc(rpmsStack, fun = mean, na.rm = T)

library(cluster)
beginCluster(n=7)
meanRPMS <- clusterR(rpmsStack,fun=calc,args=list(fun = function(x) mean(x, na.rm=TRUE)))
endCluster()

# check data
plot(meanRPMS)

# write out long-term mean
writeRaster(meanRPMS, filename = paste0("/scratch/crimmins/USDA_NPP/v2023/processed/swRPMS_1984_2022mean.tif"), format="GTiff", overwrite=TRUE)

# calculate anomaly of most recent year
currYrRaster<-raster(file_list[length(file_list)])
# load mean if needed
meanRPMS<-raster("/scratch/crimmins/USDA_NPP/v2023/processed/swRPMS_1984_2022mean.tif")

rpmsAnom<-currYrRaster-meanRPMS
writeRaster(rpmsAnom, filename = paste0("/scratch/crimmins/USDA_NPP/v2023/processed/swRPMS_2023anom.tif"), format="GTiff", overwrite=TRUE)

# percent of average
rpmsPerc<-(currYrRaster/meanRPMS)*100

writeRaster(rpmsPerc, filename = paste0("/scratch/crimmins/USDA_NPP/v2023/processed/swRPMS_2023perc.tif"), format="GTiff", overwrite=TRUE)

