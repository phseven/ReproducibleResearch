#! /usr/bin/Rscript
# ---
# title: "Plot4"
# author: "phseven"
# date: "July 11, 2014"
# ---
# Input: household_power_consumption.txt (in same directory as the R script)
# Output: plot4.png (in same directory as the R script)
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

# Set data table column names and key as (DT, TM).

setnames(pc, c("DT", "TM", "AP", "RP", "Volt",
               "Cur", "SM1", "SM2", "SM3"))

setkey(pc, DT, TM)

# Open a png device, plot 4 graphs and close the device.

png(file = "plot4.png", width=480 , height=480)

par(mfrow= c(2,2))

# Transparent background

par(bg = "transparent")

# plot1

pc[, plot(strptime(paste(DT, TM), format="%d/%m/%Y %T"), 
    AP, type="l", xlab="",
    ylab="Global Active Power (kilowatts)") ]

# plot2

pc[, plot(strptime(paste(DT, TM), format="%d/%m/%Y %T"), 
    Volt, type="l", xlab="datetime",
    ylab="Voltage") ]

# plot3

pc[, plot(strptime(paste(DT, TM), format="%d/%m/%Y %T"), 
    SM1, type="n", 
    xlab="", ylab="Energy sub metering") ]

legend("topright", 
       legend= c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       lty="solid", lwd=2, bty="n",
       col= c("black", "red", "blue"))

pc[, lines(strptime(paste(DT, TM), format="%d/%m/%Y %T"), 
    SM1, type="l", col="black")]

pc[, lines(strptime(paste(DT, TM), format="%d/%m/%Y %T"), 
    SM2, type="l", col="red")]

pc[, lines(strptime(paste(DT, TM), format="%d/%m/%Y %T"), 
    SM3, type="l", col="blue")]

# plot4

#axisTicks(c(0.0,0.5), log=FALSE, axp=c(0.0,0.5,5))
pc[, plot(strptime(paste(DT, TM), format="%d/%m/%Y %T"), 
    RP, type="l", xlab="datetime",
    ylab="Global_reactive_power") ]

# Close png file

dev.off()

# Done.
