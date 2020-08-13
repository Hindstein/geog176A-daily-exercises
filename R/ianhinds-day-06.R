# Author: "Ian Hinds"
# Date: 2020-08-11
# Purpose: daily exercise 6: Using ggplot with COVID Data

library(tidyverse)

url = 'https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-counties.csv'
covid = read_csv(url)
head(covid)

#1
# Make a faceted line plot (geom_line) of the 6 states with most cases. X axis should be the date and y should be cases.

covid %>%
  filter(date == max(date)) %>%
  group_by(state) %>%
  summarize(cases = sum(cases, na.rm = TRUE)) %>%
  ungroup() %>%
  slice_max(cases, n =6) %>%

covid %>%
  filter(state %in% c("California", "Florida", "Texas", "New York", "Georgia", "Illinois")) %>%
  group_by(state, date) %>%
  summarize(cases=sum(cases)) %>%
  ungroup() %>%
  ggplot(aes(x = date, y = cases, color = state)) +
  geom_line(size=1)

#2
#Make a columnn plot(geom_col) of daily total cases in the USA. Your X is date, y is cases.

covid %>%
  group_by(date) %>%
  summarize(cases = sum(cases)) %>%
  ggplot(aes(x = date, y = cases)) +
  geom_col(fill = "Blue", color = "blue") +
  geom_line(color = "blue", size = 2) %>%
  ggtheme::theme_classic(covid)

#END
