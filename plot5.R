#Read data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#subset data for Baltimore City
NEI_balt <- NEI[NEI$fips== "24510",]

# merge the two data sets by SCC 
NEISCC <- merge(NEI_balt, SCC, by="SCC")

# note: it is not clear, exactly which subset is meant by "motor vehicle sources"
# after examining the dataset documentation, I interpreted it as the records of 
# source sector = "Mobile - x", which are extracted with the following function
mobileRecords  <- grepl("mobile", NEISCC$EI.Sector, ignore.case=TRUE)
NEISCC_Mobile <- NEISCC[mobileRecords, ]

#aggregate total emition by year
aggregatedTotalByYear <- aggregate(Emissions ~ year, NEISCC_Mobile, sum)

#install and load ggplot2
install.packages("ggplot2")
library("ggplot2")

##plot comparing emission evolution by motor vehicle sources in Baltimore
g <- ggplot(aggregatedTotalByYear, aes(year, Emissions))
g <- g + geom_line() +
  xlab("year") +
  ylab(expression('Total PM'[2.5]*" Emissions")) +
  ggtitle('Change in total emissions from motor vehicle sources in Baltimore, 1999-2008')
print(g)
dev.copy(png, file="plot5.png", height=480, width=680)
dev.off()