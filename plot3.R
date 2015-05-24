#Read data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#subset data for Baltimore City
NEI_balt <- NEI[NEI$fips== "24510",]

#aggregate total emition by year and type
aggregatedTotalByYearAndType <- aggregate(Emissions ~ year + type, NEI_balt, sum)

#install and load ggplot2
install.packages("ggplot2")
library("ggplot2")

##plot comparing evolution by source type
par(mar=c(5,5,5,5))
g <- ggplot(aggregatedTotalByYearAndType, aes(year, Emissions, color = type))
g <- g + geom_line() +
  xlab("year") +
  ylab(expression('Total PM'[2.5]*" Emissions")) +
  ggtitle('Total Emissions in Baltimore City by source type from 1999 to 2008')
print(g)
dev.copy(png, file="plot3.png")
dev.off()