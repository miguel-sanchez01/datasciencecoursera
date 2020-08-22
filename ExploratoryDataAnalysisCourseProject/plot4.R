
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


#' 4. Across the United States, how have emissions from coal combustion-related 
#' sources changed from 1999–2008?

national <- merge(NEI, SCC, by = "SCC")

coal <- filter(national, grepl('Coal', EI.Sector))
ggplot(coal, aes(x = factor(year), y = Emissions)) + 
  geom_col(fill = '#07575B') + 
  labs(
    title = 'Fine Particulate Emissions \nCoal Combustion Related Sources \nTotal United States \n', 
    x = 'Years', y = 'Total PM2.5 Emissions in tons'
  ) + guides(fill = FALSE) + theme_bw()

#' Answer.- As shown in the graph, the accumulation of carbon shows a decreasing 
#' trend with a slight increase from 2002 to 2005, and then a decrease until 2008.


# Save file and close device ----------------------------------------------

dev.copy(png, file = "plot4.png", width = 480, height = 480)
dev.off()
