# Clint Valentine
# 04/02/2017
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
  'Airport..Name',
  'Conditions..Precipitation',
  'Conditions..Sky',
  'Effect..Indicated.Damage',
  'Effect..Impact.to.flight',
  'Effect..Other',
  'Feet.above.ground',
  'FlightDate',
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
  'airport_name',
  'conditions_precipitation',
  'conditions_sky',
  'effect_indicated_damage',
  'effect_impact_to_flight',
  'effect_other',
  'feet_above_ground',
  'flight_date',
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

# TASKS #######################################################################

# 1. How many bird strike events occurred for American Airlines?
query <- "
  SELECT COUNT (DISTINCT record_id)
  FROM events

  INNER JOIN flights
  ON events.airport_name = flights.airport_name
  AND events.flight_date = flights.flight_date

  WHERE flights.aircraft_airline_operator = 'AMERICAN AIRLINES'
"
result <- unlist(dbGetQuery(conn, query))
cat('\nNumber of bird strike events with American Airlines: ', result, '\n')


# 2. How many bird strikes were there for each airline? Show the airline name,
#    including UNKNOWN, and the number of strikes.
query <- "
  SELECT flights.aircraft_airline_operator, COUNT (DISTINCT record_id)
  FROM events

  INNER JOIN flights
  ON events.airport_name = flights.airport_name
  AND events.flight_date = flights.flight_date

  GROUP BY flights.aircraft_airline_operator
"
result <- dbGetQuery(conn, query)
cat('\nNumber of bird strikes per airline:\n\n')
print(result)


# 3. Which airline had the most bird strikes, excluding military and unknown?
query <- "
  SELECT subquery.airline, MAX(subquery.count)
  FROM (
    SELECT flights.aircraft_airline_operator as airline,
           COUNT (DISTINCT record_id) as count
    FROM events

    INNER JOIN flights
    ON events.airport_name = flights.airport_name
    AND events.flight_date = flights.flight_date

    WHERE flights.aircraft_airline_operator != 'UNKNOWN'
    AND flights.aircraft_airline_operator != 'MILITARY'

    GROUP BY flights.aircraft_airline_operator) subquery
"
result <- dbGetQuery(conn, query)
print('\nAirline with the most bird strikes (excluding military/unknown):\n\n')
print(result)

# 4. Which bird strikes occurred for Helicopters? List all the bird strike
#    incidents with date.
query <- "
  SELECT events.record_id, events.flight_date
  FROM events

  INNER JOIN flights
  ON events.airport_name = flights.airport_name
  AND events.flight_date = flights.flight_date
  INNER JOIN aircraft
  ON flights.make_model = aircraft.make_model

  WHERE aircraft.type = 'Helicopter'
"
result <- dbGetQuery(conn, query)
cat('\nBird strikes (by ID) for helicopters and date of flight:\n\n')
print(result)

# 5. Which airlines had more than 10 bird strikes? List the airline names only
#    excluding military and unknown.
query <- "
  SELECT DISTINCT flights.aircraft_airline_operator
  FROM flights

  INNER JOIN events
  ON events.airport_name = flights.airport_name
  AND events.flight_date = flights.flight_date

  WHERE 
    (events.wildlife_number_struck = '11 to 100'
     OR events.wildlife_number_struck = 'Over 100')
  AND flights.aircraft_airline_operator != 'UNKNOWN'
  AND flights.aircraft_airline_operator != 'MILITARY'
"
result <- dbGetQuery(conn, query)
cat('\nAirlines with more than 10 bird strikes excluding unknown/military:\n\n')
print(result)

