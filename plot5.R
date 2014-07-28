#! /usr/bin/Rscript
# ---
# title: "Plot5"
# author: "phseven"
# date: "July 24, 2014"
# ---
# Input: The following two files (in same directory as the R script) 
#           summarySCC_PM25.rds
#           Source_Classification_Code.rds
#
# Output: plot5.png (in same directory as the R script)
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

# Set fips as key for nei data table.

setkey(nei,fips)

# Select all rows from nei where fips = 24510 (Baltimore City)
# into bnei datatable.

bnei <- nei[fips == "24510", list(Emissions,year), keyby = SCC]

# Get all scc-s related to vehicles into veh datatable.

veh <- scc[ grepl("Vehicle",EI.Sector, ignore.case=TRUE), list(v.SCC = SCC)]

# Make v.SCC as key for veh datatable, so that it can be matched with nei.

setkey(veh, v.SCC)

# Select all bnei$SCC rows where SCC matches v.SCC values in veh datatable.
# Sum Emissions by year into snei datatable. Set year as key for snei.

snei <- bnei[veh, list(tot.emit = sum(Emissions)), keyby=year, nomatch=0]

# Open a png device, plot a histogram and close the device.

png(file = "plot5.png", width=480 , height=480)


snei[, plot(year, tot.emit, col="red", type="b",
        main=expression("Baltimore City: Vehicle Related PM"[2.5]*
                " Emission (1999 - 2008)"),
        xlog = FALSE, ylog = FALSE,
        xaxp = c(1999, 2008, 3),
        xlab ="Year", 
        ylab = expression(" PM"[2.5]*
                          "  Emission (tons)"))]
dev.off()

# Done

