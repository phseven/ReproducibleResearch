#! /usr/bin/Rscript
# ---
# title: "Plot1"
# author: "phseven"
# date: "July 11, 2014"
# ---
# Input: household_power_consumption.txt (in same directory as the R script)
# Output: plot1.png (in same directory as the R script)
# 
# Program requires some flavor of Unix (Mac OSX, linux) which supports grep
# and system() in R. The grep command reads the household_power_consumption.txt
# (2,075,259 rows) and selects only the rows from 1/2/2007 & 2/2/2007 by 
# pattern matching into a temporary file which is then loaded into a data
# table.
# 
# The data table should have 2880 rows (2 days = 2 * 24 * 60 min = 2880 min),
# 1 row per minute.

require(data.table)

# Get a temporary filename

filt.fl <- tempfile(pattern="Feb1_2_2007",fileext=".txt")

# Run grep to select only the lines from 1/2/2007 and 2/2/2007
# into tempfile

cmd <- paste( 
  "grep -e '^1/2/2007' -e '^2/2/2007'  household_power_consumption.txt > ", 
              filt.fl)
system(cmd, intern=T)

# Read the tempfile into a datatable with fread (? treated as NA).

pc <- fread(filt.fl, na.strings="?")

# Datatable should now have 2880 rows.

stopifnot(nrow(pc) == 2880)

# Set data table column names and key as AP (active power)

setnames(pc, c("DT", "TM", "AP", "RP", "Volt",
               "Cur", "SM1", "SM2", "SM3"))
setkey(pc, AP)


# Open a png device, plot a histogram and close the device.

png(file = "plot1.png", width=480 , height=480)

# Transparent background

par(bg = "transparent")

pc[,hist(AP, freq=TRUE, col="red", main="Global Active Power",
         xlab="Global Active Power (kilowatts)")]
dev.off()

# Done

