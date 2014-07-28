#! /usr/bin/Rscript
# ---
# title: "Plot1"
# author: "phseven"
# date: "July 24, 2014"
# ---
# Input: The following file (in same directory as the R script) 
#           summarySCC_PM25.rds
#
# Output: plot1.png (in same directory as the R script)
# 

require(data.table)

# Read the data

NEI <- readRDS("summarySCC_PM25.rds")

# Convert from dataframe to datatable.

nei <- as.data.table(NEI)

# Release memory of NEI
rm(NEI)

# Set year as key for nei data table.

setkey(nei, year)

# Sum Emissions by year into snei datatable. Set year as key for snei.

snei <- nei[, list(tot.emit = sum(Emissions)), keyby=year]

# Open a png device, make a base plot and close the device.

png(file = "plot1.png", width=480 , height=480)

snei[, plot(year, tot.emit / 10^6, col="red", type="b",
        main=expression("US: Decreasing Total PM"[2.5]*
                " Emission (1999 - 2008)"),
        xlog = FALSE, ylog = FALSE,
        xaxp = c(1999, 2008, 3),
        yaxp = c(3.4, 7.4, 2),
        xlab ="Year", 
        ylab = expression("Total PM"[2.5]*" Emission (million tons)"))]
dev.off()

# Done

