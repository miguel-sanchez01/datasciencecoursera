
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


# Questions ---------------------------------------------------------------

#' You must address the following questions and tasks in your exploratory analysis. 
#' For each question/task you will need to make a single plot. Unless specified, 
#' you can use any plotting system in R to make your plot.


# Packages ----------------------------------------------------------------

library(dplyr)
library(ggplot2)

head(NEI)
head(SCC)

glimpse(NEI)
summary(NEI)
apply(select(NEI, -Emissions), 2, function(x) sort(unique(x), decreasing = T))
apply(NEI, 2, function(x) sum(is.na(x)))


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

dev.copy(png, file = "./plot6.png", width = 480, height = 480)
dev.off()
