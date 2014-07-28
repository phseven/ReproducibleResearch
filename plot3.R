#! /usr/bin/Rscript
# ---
# title: "Plot3"
# author: "phseven"
# date: "July 24, 2014"
# ---
# Input: The following file (in same directory as the R script) 
#           summarySCC_PM25.rds
#
# Output: plot3.png (in same directory as the R script)
# 

require(data.table)
require(ggplot2)

# Read the data

NEI <- readRDS("summarySCC_PM25.rds")

# Convert from dataframe to datatable.

nei <- as.data.table(NEI)

# Release memory of NEI
rm(NEI)

# Set fips and year as key for nei data table.

setkey(nei, fips, type, year)

# Sum Emissions by type and year into snei datatable. 
# Set type and year as key for snei.

snei <- nei[ fips == "24510", list(tot.emit = sum(Emissions)), 
             keyby = list(type, year)]

# Open a png device, make a base plot and close the device.

png(file = "plot3.png", width=480 , height=480)

point.1999 <- snei[type == "POINT" & year == 1999, tot.emit]

qplot(year, tot.emit, data = snei, 
        colour = type, 
        main=expression("Baltimore City: Total PM"[2.5]*
                " Emission (1999 - 2008)"),
        xlab ="Year", 
        ylab = expression("Total PM"[2.5]*" Emission (tons)")) +
    geom_line() + geom_hline( yintercept = point.1999, linetype = 2 )
    

dev.off()

# Done

