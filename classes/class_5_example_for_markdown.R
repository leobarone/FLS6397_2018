library(tidyverse)
library(nycflights13)

num_flights <- flights %>% count() #Number of flights

num_airlines <- flights %>% distinct(carrier) %>% count() #Number of airlines

num_origin <- flights %>% distinct(origin) %>% count() #Number of origin airports

num_dest <- flights %>% distinct(dest) %>% count() #Number of destination airports

avg_delay <- flights %>% summarize(avg_delay=mean(dep_delay,na.rm=T)) #Average delay


flights %>% group_by(origin) %>% 
  summarize(avg_delay=mean(dep_delay,na.rm=T)) #Table of average delay by origin airport

flights %>% sample_n(10000) %>% 
  group_by(origin) %>%
  ggplot() +
  geom_point(aes(x=dep_time,y=dep_delay)) #Relationship betweeen departure time and departure delay
