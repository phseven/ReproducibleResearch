#! /usr/bin/Rscript
# ---
# title: "Plot1"
# author: "phseven"
# date: "July 24, 2014"
# ---
# Input: The following two files (in same directory as the R script) 
#           summarySCC_PM25.rds
#           Source_Classification_Code.rds
#
# Output: plot1.png (in same directory as the R script)
# 

require(data.table)

# Read the data

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Convert from dataframe to datatable.

nei <- as.data.table(NEI)
scc <- as.data.table(SCC)

# Release memory of NEI and SCC
rm(NEI)
rm(SCC)

# Set SCC as key for nei data table.

setkey(nei, SCC)

# Get all scc-s related to coal combustion into coal datatable.

coal <- scc[ grepl("Coal",EI.Sector, ignore.case=TRUE), list(c.SCC = SCC)]

# Make SCC as key for coal datatable, so that it can be matched with nei.

setkey(coal, c.SCC)

# Select all rows from nei where nei$SCC matches SCC values in coal datatable.
# Sum Emissions by year into snei datatable. Set year as key for snei.

snei <- nei[coal, list(tot.emit = sum(Emissions)), keyby=year, nomatch=0]

# Open a png device, plot a histogram and close the device.

png(file = "plot4.png", width=480 , height=480)


snei[, plot(year, tot.emit / 10^3, col="red", type="b",
        main=expression("US: Coal Combustion Related PM"[2.5]*
                " Emission (1999 - 2008)"),
        xlog = FALSE, ylog = FALSE,
        xaxp = c(1999, 2008, 3),
        xlab ="Year", 
        ylab = expression(" PM"[2.5]*
                          "  Emission (thousand tons)"))]
dev.off()

# Done

