suppressPackageStartupMessages({
library(dplyr)
library(ggplot2)
library(ggthemes)
library(lrequire)
})

df <- lrequire(apple_health_data)

setwd('/var/www/slack')


args <- commandArgs(trailingOnly = TRUE)
dash = args[1]

filename = paste("/var/www/slack/images/", dash, "-", format(Sys.time(), "%Y-%m-%d-%H-%M-%S"), ".png", sep="")

if (dash == "energy") {
df$summary %>%
      group_by(period) %>%
      summarize(calories=mean(activeEnergyBurned), goal=round(mean(activeEnergyBurnedGoal))) %>%
      ggplot(aes(x=period, y=calories)) +
      ggtitle("Active Energy Burned / Day") +
      theme_hc() + scale_colour_hc() +
      geom_bar(stat='identity', width=0.15, fill="red", color="red") +
      geom_point(aes(x=period, y=goal)) +
      geom_text(aes(y=goal, label=paste0("   ", goal), hjust=0))
} else if (dash == "exercise") {
df$summary %>%
      group_by(period) %>%
      summarize(time=mean(appleExerciseTime), goal=round(mean(appleExerciseTimeGoal))) %>%
      ggplot(aes(x=period, y=time)) +
      ggtitle("Exercise Time / Day") +
      theme_hc() + scale_colour_hc() +
      geom_bar(stat='identity', width=0.15, fill="green", color="green") +
      geom_point(aes(x=period, y=goal)) +
      geom_text(aes(y=goal, label=paste0("   ", goal), hjust=0))
} else if (dash == "stand") {
df$summary %>%
      group_by(period) %>%
      summarize(hours=mean(appleStandHours), goal=round(mean(appleStandHoursGoal))) %>%
      ggplot(aes(x=period, y=hours)) +
      ggtitle("Stand Hours / Day") +
      theme_hc() + scale_colour_hc() +
      geom_bar(stat='identity', width=0.15, fill="blue", color="blue") +
      geom_point(aes(x=period, y=goal)) +
      geom_text(aes(y=goal, label=paste0("   ", goal), hjust=0))
} else {
    print(paste("Did not know what to do with", dash))
    quit("no", 1)
}

ggsave(filename, width=6, height=4, dpi = 300)

cat(filename)
