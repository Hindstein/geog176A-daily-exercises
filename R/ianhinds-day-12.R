## Author: Ian Hinds
## Date: 23 August 2020
## Objective: Spatial Filtering

library(tidyverse)
library(sf)
library(raster)
library(ggrepel)
library(USAboundaries)

#decipher how to find state of interest through a vector call
USAboundaries::us_states()

# filter continental states (CONUS)
conus = USAboundaries::us_states() %>%
  filter(!state_name %in% c("Puerto Rico",
                                   "Alaska",
                                   "Hawaii"))

#define tn as the state of choice, through filtering us_states()
tn = USAboundaries::us_states() %>%
  st_as_sf(coords = c("lng", "lat"), crs = 4326) %>%
  filter(state_abbr %in% c("TN")) %>%

#check output
tn

#locate nearby states, through touch predicate
states = st_filter(us_states(), tn, .predicate = st_touches)

#plot map of U.S.,TN, and surrounding states
ggplot() +
  geom_sf(data = conus, fill = 'gray', size = 1) +
  geom_sf(data = tn, fill = 'orange', size = 1) +
  geom_sf(data = states, fill = 'red', size = 1, alpha = .5) +
  theme_linedraw()

