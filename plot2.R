#! /usr/bin/Rscript
# ---
# title: "Plot2"
# author: "phseven"
# date: "July 24, 2014"
# ---
# Input: The following file (in same directory as the R script) 
#           summarySCC_PM25.rds
#
# Output: plot2.png (in same directory as the R script)
# 

require(data.table)

# Read the data

NEI <- readRDS("summarySCC_PM25.rds")

# Convert from dataframe to datatable.

nei <- as.data.table(NEI)

# Release memory of NEI
rm(NEI)

# Set fips and year as key for nei data table.

setkey(nei, fips, year)

# Sum Emissions by year into snei datatable. Set year as key for snei.

snei <- nei[ fips == "24510", list(tot.emit = sum(Emissions)), keyby=year]

# Open a png device, make a base plot and close the device.

png(file = "plot2.png", width=480 , height=480)

snei[, plot(year, tot.emit / 10^3, col="red", type="b",
        main=expression("Baltimore City: Total PM"[2.5]*
                " Emission (1999 - 2008)"),
        xlog = FALSE, ylog = FALSE,
        xaxp = c(1999, 2008, 3),
        xlab ="Year", 
        ylab = expression("Total PM"[2.5]*" Emission (thousand tons)"))]
dev.off()

# Done

