## Author: Ian Hinds
## Date: 20 August 2020
## Purpose: Day 11; Measuring distance between 2 cities

#pull in necessary libraries
library(tidyverse)
library(sf)
library(units)
library(readr)

#pull in uscities data
uscities <- read_csv("data/uscities.csv")
View(uscities)

# filter US cities to include only Knox. TN, and S.B. CA
knox2sb = readr::read_csv("data/uscities.csv") %>%
  st_as_sf(coords = c("lng", "lat"), crs = 4326) %>%
  filter(city %in% c("Knoxville", "Santa Barbara")) %>%
  filter(state_id %in% c("TN", "CA"))
# check to see if filters worked
view(knox2sb)

#measures distance in meters (default)
st_distance(knox2sb)

#drop units & transform to equal area projection
st_distance(st_transform(knox2sb, 5070)) %>%
  units::drop_units()


#set units to "km", transform to equidistant projection
st_distance(st_transform(knox2sb, '+proj=eqdc +lat_0=40 +lon_0=-96 +lat_1=20 +lat_2=60 +x_0=0 +y_0=0 +datum=NAD83 +units=m +no_defs')) %>%
  units::set_units("km")


