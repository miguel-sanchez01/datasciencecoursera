
# Download archive file, if it does not exist

if(!(file.exists("summarySCC_PM25.rds") && 
     file.exists("Source_Classification_Code.rds"))) { 
  archiveFile <- "NEI_data.zip"
  if(!file.exists(archiveFile)) {
    archiveURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
    download.file(url=archiveURL,destfile=archiveFile,method="curl")
  }  
  unzip(archiveFile) 
}

## This first line will likely take a few seconds. Be patient!

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Packages ----------------------------------------------------------------

library(dplyr)
library(ggplot2)


#' 5. How have emissions from motor vehicle sources changed from 1999–2008 in 
#' Baltimore City?

baltimore_vehicle <- filter(
  national, 
  fips == "24510", 
  type %in% c("ON-ROAD", "NON-ROAD")
)

ggplot(baltimore_vehicle,  aes(x = factor(year), y = Emissions)) + 
  geom_col(fill = '#34675C') + 
  labs(
    title = " Fine Particulate Emissions\n Motor Vehicle Sources \n Baltimore City\n",
    x = 'Years',
    y = 'Total PM2.5 Emissions in tons'
  ) + guides(fill = FALSE) + theme_bw()

#' Answer.- the accumulation of coal shows a decreasing trend with a slight 
#' increase from 2002 to 2005, then a decrease until 2008

# Save file and close device ----------------------------------------------

dev.copy(png, file = "plot5.png", width = 480, height = 480)
dev.off()
