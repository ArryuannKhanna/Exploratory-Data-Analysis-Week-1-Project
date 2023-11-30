plot4 <- function() {
 # Purpose of this function:
# 1. Load data from the 'household_power_consumption.txt' file.
# 2. Extract data for two specific days: 2007-02-01 and 2007-02-02.
# 3. Generate four plots collectively displaying Global Active Power, Voltage, Energy Sub Metering, and Global Reactive Power over time.
  
# Parameters: None
# Assumes the 'household_power_consumption.txt' file is present in the working directory.

  
  ## Read the data
  powerdata <- read.table("./household_power_consumption.txt", stringsAsFactors = FALSE, header = TRUE, sep = ";")
  
  ## Create a new column in the table with date and time merged together
  FullTimeDate <- strptime(paste(powerdata$Date, powerdata$Time, sep=" "), "%d/%m/%Y %H:%M:%S")
  powerdata <- cbind(powerdata, FullTimeDate)
  
  ## Change the class of relevant columns to the correct class
  powerdata$Date <- as.Date(powerdata$Date, format="%d/%m/%Y")
  powerdata$Time <- format(powerdata$Time, format="%H:%M:%S")
  numeric_columns <- c("Global_active_power", "Global_reactive_power", "Voltage", "Global_intensity", "Sub_metering_1", "Sub_metering_2", "Sub_metering_3")
  powerdata[, numeric_columns] <- lapply(powerdata[, numeric_columns], as.numeric)
  
  ## Subset data for the specified days
  subsetdata <- subset(powerdata, Date == "2007-02-01" | Date =="2007-02-02")
  
  ## Plot the four graphs
  png("plot4.png", width=480, height=480)
  par(mfrow=c(2,2))
  
  ## Plot 1: Global Active Power vs. Time
  with(subsetdata, plot(FullTimeDate, Global_active_power, type="l", xlab="", ylab="Global Active Power"))
  
  ## Plot 2: Voltage vs. Time
  with(subsetdata, plot(FullTimeDate, Voltage, type="l", xlab="Datetime", ylab="Voltage"))
  
  ## Plot 3: Energy Sub Metering vs. Time
  with(subsetdata, {
    plot(FullTimeDate, Sub_metering_1, type="l", xlab="", ylab="Energy Sub Metering")
    lines(FullTimeDate, subsetdata$Sub_metering_2, type="l", col="red")
    lines(FullTimeDate, subsetdata$Sub_metering_3, type="l", col="blue")
    legend("topright", legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty=1, lwd=2, col=c("black", "red", "blue"))
  })
  
  ## Plot 4: Global Reactive Power vs. Time
  with(subsetdata, plot(FullTimeDate, Global_reactive_power, type="l", xlab="Datetime", ylab="Global Reactive Power"))
  
  dev.off()
}
