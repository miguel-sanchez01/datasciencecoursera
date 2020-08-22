
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


#' 3. Of the four types of sources indicated by the type (point, nonpoint, onroad, 
#' nonroad) variable, which of these four sources have seen decreases in emissions 
#' from 1999–2008 for Baltimore City? Which have seen increases in emissions from 
#' 1999–2008? Use the ggplot2 plotting system to make a plot answer this question.

totalEmissionType <- NEI %>% 
  filter(fips == "24510") %>% 
  group_by(type, year) %>% 
  summarise(totalEmission = sum(Emissions))

ggplot(totalEmissionType, aes(x = factor(year), y = totalEmission, fill = type)) +
  geom_col() + facet_wrap(. ~ type, ncol = 4) + 
  scale_fill_manual(values = c('#375E97', '#FB6542', '#FFBB00', '#3F681C')) +
  labs(
    title = 'Fine Particulate Emissions, Baltimore City', 
    x = 'Years', y = 'Total PM2.5 Emissions in tons'
  ) + guides(fill = FALSE) + theme_bw()

#' Answer.-  the “NON-ROAD”, “NONPOINT” and “ON-ROAD” type of sources have shown 
#' a decrease in the total PM2.5 Emissions. “POINT”  type of source, shows the 
#' increase in the total PM2.5 emissions from 1999-2005 but again a decrease in 2008 


# Save file and close device ----------------------------------------------

dev.copy(png, file = "plot3.png", width = 480, height = 480)
dev.off()
