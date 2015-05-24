#Read data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#subset data for Baltimore City
NEI_balt_LA <- subset(NEI, fips== "24510" | fips== "06037")

# merge the two data sets by SCC 
NEISCC <- merge(NEI_balt_LA, SCC, by="SCC")

# note: it is not clear, exactly which subset is meant by "motor vehicle sources"
# after examining the dataset documentation, I interpreted it as the records of 
# source sector = "Mobile - x", which are extracted with the following function
mobileRecords  <- grepl("mobile", NEISCC$EI.Sector, ignore.case=TRUE)
NEISCC_Mobile <- NEISCC[mobileRecords, ]

#aggregat total emition by year and fips and rename fips
aggregatedTotalByYearAndFips <- aggregate(Emissions ~ year + fips, NEISCC_Mobile, sum)
aggregatedTotalByYearAndFips$fips[aggregatedTotalByYearAndFips$fips=="24510"] <- "Baltimore, MD"
aggregatedTotalByYearAndFips$fips[aggregatedTotalByYearAndFips$fips=="06037"] <- "Los Angeles, CA"

#install and load ggplot2
install.packages("ggplot2")
library("ggplot2")

##plot comparing emission evolution from motor vehicle sources in Baltimore and LA
g <- ggplot(aggregatedTotalByYearAndFips, aes(year, Emissions, col=fips))
g <- g + geom_line() +
  xlab("year") +
  ylab(expression('Total PM'[2.5]*" Emissions")) +
  ggtitle('Change in total emissions from motor vehicle sources in Baltimore and LA, 1999-2008')
print(g)
dev.copy(png, file="plot6.png", height=480, width=680)
dev.off()