# Clint Valentine
# 03/25/2017
rm(list = ls())

library(RSQLite)

# Make the SQLite DataBase for bird strikes.
conn <- dbConnect(RSQLite::SQLite(), dbname='bird.strikes.sqlite')

# Load in the data into one data.frame if it has not already been loaded.
if (exists('bird.strikes') == F) {
  unzip('Bird Strikes.zip')
  # Escape sep = ',' in quotations
  # Impute NA as empty strings
  # Do not consider strings factors
  bird.strikes <- read.table(
    file = 'Bird Strikes.csv',
    fill = T,
    header = T,
    na.strings = '',
    quote = '\"',
    sep = ',',
    stringsAsFactors = F
  )
}

# Break out the three tables into three data.frames.
aircraft <- bird.strikes[, c(
  'Aircraft..Make.Model',
  'Aircraft..Type',
  'Aircraft..Number.of.engines.'
)]

flights <- bird.strikes[, c(
  'Aircraft..Flight.Number',
  'Aircraft..Make.Model',
  'Airport..Name',
  'Aircraft..Airline.Operator',
  'Cost..Aircraft.time.out.of.service..hours.',
  'Cost..Repair..inflation.adj.',
  'FlightDate',
  'Pilot.warned.of.birds.or.wildlife.'
)]

events <- bird.strikes[, c(
  'Record.ID',
  'Altitude.bin',
  'Conditions..Precipitation',
  'Conditions..Sky',
  'Effect..Indicated.Damage',
  'Effect..Impact.to.flight',
  'Effect..Other',
  'Feet.above.ground',
  'Aircraft..Flight.Number',
  'Location..Nearby.if.en.route',
  'Remains.of.wildlife.collected.',
  'Remarks',
  'Reported..Date',
  'Speed..IAS..in.knots',
  'When..Time..HHMM.',
  'Wildlife..Number.struck',
  'Wildlife..Size',
  'Wildlife..Species'
)]

# Remove all NA rows and make unique entries.
aircraft <- unique(aircraft[rowSums(is.na(aircraft)) != ncol(aircraft),])
flights <- unique(flights[rowSums(is.na(flights)) != ncol(flights),])
events <- unique(events[rowSums(is.na(events)) != ncol(events),])

# Remove rownames and add simpler column names for DB table fields.
rownames(aircraft) <- NULL
rownames(flights) <- NULL
rownames(events) <- NULL

colnames(aircraft) <- c(
  'make_model',
  'type',
  'num_engines'
)
colnames(flights) <- c(
  'flight_number',
  'make_model',
  'airport_name',
  'aircraft_airline_operator',
  'cost_aircraft_time_out_hours',
  'cost_repair_inflation_adj',
  'flight_date',
  'pilot_warned_of_wildlife'
)
colnames(events) <- c(
  'record_id',
  'altitude_bin',
  'conditions_precipitation',
  'conditions_sky',
  'effect_indicated_damage',
  'effect_impact_to_flight',
  'effect_other',
  'feet_above_ground',
  'flight_number',
  'location_nearby_if_en_route',
  'remains_wildlife_collected',
  'remarks',
  'reported_date',
  'speed_IAS_knots',
  'when_HHMM',
  'wildlife_number_struck',
  'wildlife_size',
  'wildlife_species'
)

# STORING #####################################################################

# Write the aircraft data.frame to the aircraft table.
dbWriteTable(con=conn,
             name='aircraft',
             value=aircraft,
             row.names=F,
             overwrite=T)

# Write the flights data.frame to the flights table.
dbWriteTable(con=conn,
             name='flights',
             value=flights,
             row.names=F,
             overwrite=T)

# Write the events data.frame to the events table.
dbWriteTable(con=conn,
             name='events',
             value=events,
             row.names=F,
             overwrite=T)

# TESTING #####################################################################

# The following statement returns 2 engines for the AEROSTAR 600 aircraft.
#
# $ print(result)
#
#    num_engines
#  1           2
#
query <- "SELECT num_engines FROM aircraft WHERE make_model = 'AEROSTAR 600'"
result <- dbGetQuery(conn, query)
print(result)
cat('\n')

# The following statement returns the unique aircraft that have been involved
# in an bird strike event with 11 to 100 birds. This statement uses the INNER
# JOIN SQL syntax to query all three tables e.g. events -> flights -> aircraft.
# It turns out 124 / 554 unique aircraft models have had air strikes with 11 to
# 100 birds at one time.
#
# $ print(tail(result))
# 
#           make_model
#   119        CRJ-440
#   120   AGUSTA A 119
#   121  SIKORSKY S-92
#   122          HH-65
#   123     HAWKER 900
#   124 B-747-8 SERIES
#
# $cat("\nNumber of aircraft:", (nrow(result)), "at",
#      round(nrow(result)/nrow(aircraft) * 100), '%')
#
#  Number of aircraft: 124 at 23 %
#
query <- "
  SELECT DISTINCT aircraft.make_model
  FROM aircraft
  INNER JOIN flights
  ON aircraft.make_model = flights.make_model
  INNER JOIN events
  ON flights.flight_number = events.flight_number
  AND events.wildlife_number_struck = '11 to 100'
"
result <- dbGetQuery(conn, query)

print(tail(result))

cat("\nNumber of aircraft:", (nrow(result)), "at",
    round(nrow(result)/nrow(aircraft) * 100), '%')
