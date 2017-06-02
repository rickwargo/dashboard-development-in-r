library(lubridate)
library(XML)

#load apple health export.xml file
xml <- xmlParse("./apple_health_data.xml")

#transform xml file to data frame - select the Record rows from the xml file
steps.df <- XML:::xmlAttrsToDataFrame(xml['//Record[@type="HKQuantityTypeIdentifierStepCount"]'], stringsAsFactors = FALSE)

#make value variable numeric
steps.df$value <- as.numeric(steps.df$value)

#make endDate in a date time variable POSIXct using lubridate with eastern time zone
steps.df$endDate <- ymd_hms(steps.df$endDate, tz="America/New_York")

##add in year month date dayofweek hour period columns
steps.df$month <- format(steps.df$endDate,"%m")
steps.df$year <- format(steps.df$endDate,"%Y")
steps.df$date <- format(steps.df$endDate,"%Y-%m-%d")
steps.df$dayofweek <- wday(steps.df$endDate, label=TRUE, abbr=FALSE)
steps.df$hour <- format(steps.df$endDate,"%H")
steps.df$period <- format(steps.df$endDate, "%Y-%m")
steps.df <- steps.df[steps.df$period>"2016-09",]

summary.df <- XML:::xmlAttrsToDataFrame(xml["//ActivitySummary"], stringsAsFactors = FALSE)
summary.df$activeEnergyBurned <- as.double(summary.df$activeEnergyBurned)
summary.df$activeEnergyBurnedGoal <- as.double(summary.df$activeEnergyBurnedGoal)
summary.df$appleExerciseTime <- as.double(summary.df$appleExerciseTime)
summary.df$appleExerciseTimeGoal <- as.double(summary.df$appleExerciseTimeGoal)
summary.df$appleStandHours <- as.double(summary.df$appleStandHours)
summary.df$appleStandHoursGoal <- as.double(summary.df$appleStandHoursGoal)

summary.df$endDate <- ymd(summary.df$dateComponents, tz="America/New_York")
##add in year month date dayofweek period columns
summary.df$month <- format(summary.df$endDate,"%m")
summary.df$year <- format(summary.df$endDate,"%Y")
summary.df$date <- format(summary.df$endDate,"%Y-%m-%d")
summary.df$dayofweek <- wday(summary.df$endDate, label=TRUE, abbr=FALSE)
summary.df$period <- format(summary.df$endDate, "%Y-%m")
summary.df <- summary.df[summary.df$period>"2016-09",]

module.exports <- list(steps=steps.df, summary=summary.df)
