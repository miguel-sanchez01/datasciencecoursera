
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


#' 2. Have total emissions from PM2.5 decreased in the Baltimore City, Maryland 
#' (fips == "24510") from 1999 to 2008? Use the base plotting system to make a 
#' plot answering this question.

totalEmissionBaltimore <- NEI %>% 
  filter(fips == "24510") %>% 
  group_by(year) %>% 
  summarise(totalEmission = sum(Emissions))

barplot(
  totalEmission ~ year,
  data = totalEmissionBaltimore,
  xlab = "Year",
  ylab = "Total PM2.5 Emissions",
  main = "Total PM2.5 Emissions From Baltimore City"
)

#' Answer.- the total PM2.5 from Baltimore City have not continously decreased, 
#' they decreased from 1999 to 2002, but have increasedin 2005 and then decreased.

# Save file and close device ----------------------------------------------

dev.copy(png, file = "plot2.png", width = 480, height = 480)
dev.off()
