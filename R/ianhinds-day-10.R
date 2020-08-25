# Author: Ian Hinds
# Date: 18 August 2020
# Purpose: Using Multistring method to maintain landborder data.


USAboundaries::us_states()

conus = USAboundaries::us_states() %>%
  filter(!state_name %in% c("Puerto Rico",
                            "Alaska",
                            "Hawaii"))

conus
# Error in data.matrix(data) : 'list' object cannot be coerced to type 'double'
length(st_geometry(conus))

(comb_multi = st_combine(conus) %>%
  st_cast("MULTILINESTRING"))

(union_multi = st_union(conus) %>%
  st_cast("MULTILINESTRING"))
