
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


#' 6. Compare emissions from motor vehicle sources in Baltimore City with emissions 
#' from motor vehicle sources in Los Angeles County, California fips == "06037"). 
#' Which city has seen greater changes over time in motor vehicle emissions?

road_vehicles <- filter(
  national,
  fips %in% c("24510", "06037"),
  type %in% c("ON-ROAD", "NON-ROAD")
) %>% mutate(
  fipsName = case_when(
    fips == "24510" ~ "Baltimore",
    TRUE ~ "Los Angeles"
  )
)

ggplot(road_vehicles, aes(x = factor(year), y = Emissions)) +
  geom_col(fill = '#34675C') + 
  labs(
    title = "Comparison Vehicles Emissions"
  ) + facet_wrap(. ~ fipsName) + theme_bw()

#' It is observed that Los Angeles County has seen greater changes over time in 
#' vehicle emissions.

# Save file and close device ----------------------------------------------

dev.copy(png, file = "plot6.png", width = 480, height = 480)
dev.off()
