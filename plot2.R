#Read data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#subset data for Baltimore City
NEI_balt <- NEI[NEI$fips== "24510",]

#aggregate and plot total emition by year
aggregatedTotalByYear <- aggregate(Emissions ~ year, NEI_balt, sum)

par(mar=c(5,5,5,5))
barplot(height=aggregatedTotalByYear$Emissions, names.arg=aggregatedTotalByYear$year, xlab="year", ylab=expression('total PM'[2.5]*' emission'),main=expression('Total PM'[2.5]*' in Baltimore City per various year'))
dev.copy(png, file="plot2.png")
dev.off()