#Read data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# merge the two data sets by SCC 
NEISCC <- merge(NEI, SCC, by="SCC")

# extract all records with the word "coal" in their short name
coalRecords  <- grepl("coal", NEISCC$Short.Name, ignore.case=TRUE)
NEISCC_Coal <- NEISCC[coalRecords, ]

#aggregate total emition by year
aggregatedTotalByYear <- aggregate(Emissions ~ year, NEISCC_Coal, sum)

#install and load ggplot2
install.packages("ggplot2")
library("ggplot2")

##plot comparing emission evolution from coal sources 
g <- ggplot(aggregatedTotalByYear, aes(year, Emissions))
g <- g + geom_line() +
  xlab("year") +
  ylab(expression('Total PM'[2.5]*" Emissions")) +
  ggtitle('Change in total emissions from coal sources in USA, 1999 - 2008')
print(g)
dev.copy(png, file="plot4.png")
dev.off()