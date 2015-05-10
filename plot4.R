Sys.setlocale("LC_ALL","C")
if (!exists("dat")) {
  # Load data if not existing yet -
  # 0 download the zip-file and unpack it:
  temp <- tempfile()
  download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",temp)
  file <- unz(temp, "household_power_consumption.txt")
  
  # 1. read in the header from the text-file:
  raw1 <- read.table(file, sep=";", na.strings = "?", header=TRUE ,nrows = 1)
  classes <- sapply(raw1, class)
  
  # 2. read in 5000 rows from line 56000 on, using information about the header from above:
  file <- unz(temp, "household_power_consumption.txt")
  raw2 <- read.table(file, sep=";", na.strings = "?", header=FALSE, colClasses = classes, skip = 65000 ,nrows = 5000)
  names(raw2) <- names(raw1)
  
  # 3. subset 2 days out of the 5000 rows from data.frame "raw2":
  dat <- subset(raw2, (Date=="1/2/2007") | (Date=="2/2/2007"))
  unlink(temp)
  
  # 4. transform the first two factor-variables into a Date and a Time variable:
  dat$Time  <- strptime(paste(dat$Date,dat$Time),format = "%d/%m/%Y %H:%M:%S", tz = "")
  dat$Date <- as.Date(dat$Date,"%d/%m/%Y")
}

#PLOT 4
par(mfrow = c(2, 2), mar = c(4, 4, 2, 1))  #oma = c(0, 0, 0, 0)
with(dat, {
  plot(Time, Global_active_power,type="l", ylab = "Global Active Power", xlab="", cex.lab=0.7)
  plot(Time, Voltage, xlab = "datetime",type="l", cex.lab=0.7)
  plot(Time, Sub_metering_1, type="n", xlab = "", ylab = "")
  title(ylab = "Energy sub metering", cex.lab=0.7)
  with(dat, lines(Time, Sub_metering_1, col ="black")) 
  with(dat, lines(Time, Sub_metering_2, col ="red")) 
  with(dat, lines(Time, Sub_metering_3, col ="blue")) 
  legend("topright", lty = 1, bty="n", col = c("black", "red","blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), cex=0.7,y.intersp=0.5)
  
  plot(Time, Global_reactive_power, xlab = "datetime",type="l", cex.lab=0.7)
})

dev.copy(png, file = "plot4.png", width=480, height=480) 
#  The default unit is pixels, no units parameter required
dev.off()  # close PNG device




