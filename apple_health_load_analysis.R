library(dplyr)
library(ggplot2)
library(lubridate)
library(lrequire)

setwd('~/Code/R/dashboard-development-in-r')
df <- lrequire(apple_health_data, force.reload = F)
str(df)

#show average steps/day by month by year using dplyr then graph using ggplot2
df$steps %>%
  group_by(period) %>%
  summarize(steps=sum(value)/n_distinct(date)) %>%
  ggplot(aes(x=period, y=steps)) +
  geom_bar(stat='identity') +
  scale_y_continuous(labels = scales::comma) +
  scale_fill_brewer() +
  theme_bw() +
  theme(panel.grid.major = element_blank())

#boxplot data by month by year
df$steps %>%
  group_by(date,period) %>%
  summarize(steps=sum(value)/n_distinct(date)) %>%
  ggplot(aes(x=period, y=steps)) +
  geom_boxplot() +
  scale_fill_brewer() +
  theme_bw() +
  theme(panel.grid.major = element_blank())


#summary statistics by period
df$steps %>%
  group_by(date,period) %>%
  summarize(steps=sum(value)) %>%
  group_by(period) %>%
  summarize(mean = round(mean(steps), 2), sd = round(sd(steps), 2),
            median = round(median(steps), 2), max = round(max(steps), 2),
            min = round(min(steps), 2),`25%`= quantile(steps, probs=0.25),
            `75%`= quantile(steps, probs=0.75))

#boxplot data by day of week year
df$steps %>%
  group_by(dayofweek,date,year) %>%
  summarize(steps=sum(value)) %>%
  #print table steps by date by month by year
  # print (n=100) %>%
  ggplot(aes(x=dayofweek, y=steps)) +
  geom_boxplot(aes(fill=(year))) +
  scale_fill_brewer() +
  theme_bw() +
  theme(panel.grid.major = element_blank())

#summary statistics by day of week for 2016
df$steps %>%
  group_by(dayofweek,date,year) %>%
  summarize(steps=sum(value)) %>%
  group_by(dayofweek) %>%
  summarize(mean = round(mean(steps), 2), sd = round(sd(steps), 2),
            median = round(median(steps), 2), max = round(max(steps), 2),
            min = round(min(steps), 2),`25%`= quantile(steps, probs=0.25),
            `75%`= quantile(steps, probs=0.75)) %>%
  arrange(desc(median))

#heatmap day of week hour of day
df$steps %>%
  group_by(date,dayofweek,hour) %>%
  summarize(steps=sum(value)) %>%
  group_by(hour,dayofweek) %>%
  summarize(steps=sum(steps)) %>%
  arrange(desc(steps)) %>%
  #print table steps by date by month by year
  # print (n=100) %>%
  ggplot(aes(x=dayofweek, y=hour, fill=steps)) +
  geom_tile() +
  scale_fill_continuous(labels = scales::comma, low = 'white', high = 'red') +
  theme_bw() +
  theme(panel.grid.major = element_blank())

str(df$summary)

df$summary %>%
  group_by(date,period) %>%
  summarize(calories=mean(activeEnergyBurned)) %>%
  ggplot(aes(x=period, y=calories)) +
  # geom_bar(stat='identity') +
  geom_boxplot(aes()) +
  scale_y_continuous(labels = scales::comma) +
  scale_fill_brewer() +
  theme_bw() +
  theme(panel.grid.major = element_blank())

library(ggthemes)
install.packages("ggthemes")

df$summary %>%
  group_by(period) %>%
  summarize(calories=mean(activeEnergyBurned), goal=round(mean(activeEnergyBurnedGoal))) %>%
  ggplot(aes(x=period, y=calories)) +
  ggtitle("Average Calories Burned / Day") +
  theme_hc() + scale_colour_hc() +
  geom_bar(stat='identity', width=0.15, fill="red", color="red") +
  geom_point(aes(x=period, y=goal)) +
  geom_text(aes(y=goal, label=paste0("   ", goal), hjust=0))

df$summary %>%
  group_by(period) %>%
  summarize(time=mean(appleExerciseTime), goal=round(mean(appleExerciseTimeGoal))) %>%
  ggplot(aes(x=period, y=time)) +
  ggtitle("Exercise Time / Day") +
  theme_hc() + scale_colour_hc() +
  geom_bar(stat='identity', width=0.15, fill="green", color="green") +
  geom_point(aes(x=period, y=goal)) +
  geom_text(aes(y=goal, label=paste0("   ", goal), hjust=0))
