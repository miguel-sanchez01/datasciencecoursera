
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


#' 1. Have total emissions from PM2.5 decreased in the United States from 1999 
#' to 2008? Using the base plotting system, make a plot showing the total PM2.5 
#' emission from all sources for each of the years 1999, 2002, 2005, and 2008.

totalEmission <- NEI %>% 
  group_by(year) %>% 
  summarise(totalEmission = sum(Emissions))

barplot(
  totalEmission ~ year,
  data = totalEmission,
  xlab = "Year",
  ylab = "Total PM2.5 Emissions",
  main = "Total PM2.5 Emissions From All US Sources"
)

#' Answer.- the total emissions have decreased in the US from 1999 to 2008


# Save file and close device ----------------------------------------------

dev.copy(png, file = "plot1.png", width = 480, height = 480)
dev.off()
