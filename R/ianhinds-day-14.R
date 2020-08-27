## Author: Ian Hinds
## Date: 25 Aug 2020
## Purpose: Writing Functions pt.1


library(tidyverse)
library(readr)
library(sf)
library(USAboundaries)


#define function "get conus"
get_conus = function(data, var){
  conus = filter(data, !get(var) %in% c("Puerto Rico",
                                        "Hawaii",
                                        "Alaska", "Guam",
                                        "District of Columbia"))
  return(conus)
}

nrow(conus)

#plot us_states using g_conus
x = get_conus(us_states(), "name")
plot(x$geometry)

#try with cities
x2 = get_conus(us_cities(), "state_name")
plot(x2$geometry)

#Todays work
#read in uscities.csv
cities = read_csv("./data/uscities.csv") %>%
  st_as_sf(coords = c("lng", "lat"), crs = 4326) %>%
  st_transform(5070) %>%
  get_conus("state_name")
#plot with pch and cex filters to limit highlights
plot(cities$geometry, pch = 16, cex = .05)

#conus
conus2 = st_transform(us_counties(), 5070) %>%
  select(name, geoid, state_name) %>%
  get_conus("state_name")


#make mulipolygon
citypoly = st_join(conus2, cities)
citypoly

#count points and plot
count(citypoly, geoid)
plot(citypoly['Cities per State'])

#make pip
pip3 = function(points, polygon, id){
  st_join(polygon, points) %>%
    st_drop_geometry() %>%
    count(.data[[id]]) %>%
    setNames(c(id, "Cities per State")) %>%
    left_join(polygon, by = id) %>%
    st_as_sf()

}


conus3 = get_conus(us_states(), "name") %>%
  st_transform(5070)

conus_cities = pip3(cities, conus3, 'name')

plot(conus_cities['Cities per State'])

#####
joincity = st_join(conus2, cities) %>%
  st_drop_geometry() %>%
  count(name) %>%
  left_join(conus2, by = "geoid")

plot_pip = function(data, var){
  ggplot() +
    geom_sf(data = data, aes(color = get(var)), size = .1) +
    scale_color_gradient(low = "gray", high = "black") +
    theme_void() +
    theme(legend.position = "bottom")
}

plot_pip(citypoly, geoid) %>%
  plot_pip()
#####
