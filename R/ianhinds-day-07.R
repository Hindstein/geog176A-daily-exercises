#---
# Author: "Ian Hinds"
# Date: 2020-08-13
# Purpose: Day 7 assignment: joining, pivots, splits, plots

#1
# Make a faceted plot of the cumulative cases & deaths by USA region. Your x axis is date, y axis is value/count. Join and pivot the covid 19 data.
#read covid data
library(tidyverse)

url = 'https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-counties.csv'
covid = read_csv(url)
head(covid)

#state and region of US classification (N,W,S,E)
region = data.frame(state = state.name, region = state.region)

head(region)

#filter state names and current date, list number of cases per state
covid %>%
  filter(!state %in% state.name) %>%
  filter(date == max(date)) %>%
  count(state)

#full join data
inner_join(covid, region, by = "state") %>%
  count(region) %>%
  mutate(tot = sum(n))

full_join(covid, region, by = "state") %>%
  count(region) %>%
  mutate(tot = sum(n))

#right join/ pivot
covid %>%
  right_join(region, by = "state") %>%
  group_by(region, date) %>%
  summarize(cases = sum(cases),
            deaths = sum(deaths)) %>%
  pivot_longer(cols = c('cases', 'deaths')) %>%

#plot
ggplot(aes(x = date, y = value)) +
  geom_line(aes(col = region)) +
  facet_grid(name~region, scale = "free_y") +
  theme_linedraw() +
  theme(legend.position = "bottom")

