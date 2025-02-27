# DETERMINE THE HIGHEST VOLUME HOURS ON WEEKDAYS

library("dplyr")
library("lubridate")

# Load the trip data with no outliers
trips <- readRDS("trip_no_outliers.rds")

# Convert the starting time to date format
trips <- trips %>% mutate(start_date = mdy_hm(start_date))

# Identify which day each trip started on
trips$weekday = weekdays(trips$start_date)

# Determine if there are any duplicate entries in the 
table(trips$start_station_name)
  # Post at Kearney and Post at Kearny (have same ID)
  # Washington at Kearney and Washington at Kearney (have same ID)

#### Determine rush hours through all weekdays

# Build function to determine the peak hours 
rush_hour <- function(trip_data, week_day) {
  # Build new dataframe with trips for only the specificied weekday
  trip_day_df <- trip_data[trip_data$weekday == week_day,]
  # Create new variable that summarizes the hour the trip started
  trip_day_df$hour = as.numeric(format(trip_day_df$start_date, "%H"))
  # Create summary histogram
  hist(trip_day_df$hour, main = paste("Numer of Trips Throughout", week_day), xlab = "Time in Hours")
}

# Determine rush hours for Mondays
rush_hour(trips, "Monday")

# Determine rush hours for Tuesdays
rush_hour(trips, "Tuesday")

# Determine rush hours for Wednesdays
rush_hour(trips, "Wednesday")

# Determine rush hours for Thursdays
rush_hour(trips, "Thursday")

# Determine rush hours for Fridays
rush_hour(trips, "Friday")

# Build new dataframe with all weekdays
weekday_trips <- trips[trips$weekday == "Monday" | trips$weekday == "Tuesday" | 
                       trips$weekday == "Wednesday" | trips$weekday == "Thursday" |
                       trips$weekday == "Friday", ]

# Create new column that takes the "hour" the trip begin at
weekday_trips$hour = as.numeric(format(weekday_trips$start_date, "%H"))

# Plot hours on a histogram for visualization
hist(weekday_trips$hour, main = "Numer of Trips Throughout Weekdays", xlab = "Time in Hours")
# Rush hours are 8:00 (8am)
# And 17:00 5(pm)

#### Determine the busiest 10 starting and ending stations during rush hours on weekdays

# Create new dataframe with only the trips during the morning rush hour
morning_rush <- weekday_trips[weekday_trips$hour == 8,]

# Create a table containing the 10 busiest starting station in order
morning_starting <- table(morning_rush$start_station_id)
morning_starting <- sort(morning_starting, decreasing = T, na.rm = T)[1:10]
ms_proportion <- sum(morning_starting)/nrow(trips)

# Plot the 10 busiest starting station in the morning rush hour
barplot(morning_starting, 
        main = "Ten Busiest Starting Stations During Morning Rush Hour",
        ylab = "Number of Trips",
        cex.lab = 1.3,
        cex.axis = 1,
        cex.names = 0.6,
        ylim = c(0,6500),
        las = 2)

# Create a table containing the 10 busiest ending station in order
morning_ending <- table(morning_rush$end_station_id)
morning_ending <- sort(morning_ending, decreasing = T, na.rm = T)[1:10]

# Determine the proportion of all trips that the stations make up
me_proportion <- sum(morning_ending)/nrow(trips)

# Plot the 10 busiest ending stations in the morning rush hour
barplot(morning_ending, 
        main = "Ten Busiest Ending Stations During Morning Rush Hour",
        ylab = "Number of Trips",
        cex.lab = 1.3,
        cex.axis = 1.2,
        cex.names = 1.2,
        ylim = c(0,3500),
        las = 2)

# Create a new dataframe with only the trips during the evening rush hour
evening_rush <- weekday_trips[weekday_trips$hour == 17,]

# Create a table containing the 10 busiest starting station in order
evening_starting <- table(evening_rush$start_station_id)
evening_starting <- sort(evening_starting, decreasing = T, na.rm = T)[1:10]

# Determine the proportion of all trips that the stations make up
es_proportion <- sum(evening_starting)/nrow(trips)

# Plot the 10 busiest starting station in the evening rush hour
barplot(evening_starting, 
        main = "Ten Busiest Starting Stations During Evening Rush Hour",
        ylab = "Number of Trips",
        cex.lab = 1.3,
        cex.axis = 1.2,
        cex.names = 1.2,
        ylim = c(0,2000),
        las = 2)

# Create a table containing the 10 busiest ending station in order
evening_ending <- table(evening_rush$end_station_id)
evening_ending <- sort(evening_ending, decreasing = T, na.rm = T)[1:10]

# Determine the proportion of all trips that the stations make up
ee_proportion <- sum(evening_ending)/nrow(trips)

# Plot the 10 busiest ending stations in the evening rush hour
barplot(evening_ending, 
        main = "Ten Busiest Ending Stations During Evening Rush Hour",
        ylab = "Number of Trips",
        cex.lab = 1.3,
        cex.axis = 1.2,
        cex.names = 1.2,
        ylim = c(0,7000),
        las = 2)

##### Determine the busiest 10 stations during weekends

# Build new dataframe with only weekends
weekend_trips <- trips[trips$weekday == "Saturday" | trips$weekday == "Sunday",]

# Make a table including the 10 most frequent starting stations on weekends
weekend_starting <- table(weekend_trips$start_station_id)
weekend_starting <- sort(weekend_starting, decreasing = T, na.rm = T)[1:10]

# Determine the proportion of all trips that the stations make up
ws_proportion <- sum(weekend_starting)/nrow(trips)

# Plot the 10 busiest starting stations during the weekend
barplot(weekend_starting, 
        main = "Ten Busiest Starting Stations During Weekends",
        ylab = "Number of Trips",
        cex.lab = 1.3,
        cex.axis = 1.2,
        cex.names = 1.2,
        ylim = c(0,2500),
        las = 2)

# Make a table including the 10 most frequent ending stations on weekends
weekend_ending <- table(weekend_trips$end_station_id)
weekend_ending <- sort(weekend_ending, decreasing = T, na.rm = T)[1:10]

# Determine the proportion of all trips that the stations make up
ws_proportion <- sum(weekend_starting)/nrow(trips)

# Plot the 10 busiest ending stations during the weekend
barplot(weekend_ending, 
        main = "Ten Busiest Ending Stations During Weekends",
        ylab = "Number of Trips",
        cex.lab = 1.3,
        cex.axis = 1.2,
        cex.names = 1.2,
        ylim = c(0,2500),
        las = 2)
# Determine the proportion of all trips that the stations make up
we_proportion <- sum(weekend_ending)/nrow(trips)
