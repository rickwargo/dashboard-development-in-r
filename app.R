library(shinydashboard)
library(dplyr)
library(ggplot2)
library(ggthemes)
library(lrequire)

df <- lrequire(apple_health_data)

startDate = df$summary$endDate[length(df$summary$endDate)]

summaryIndex <- function(dt) {
  len = length(df$summary$endDate)
  offset = as.Date(startDate) - dt
  return(len-offset)
}

theDate <- function(dt) {
  # Find index based on date selected
  a <- df$summary$endDate
  return(a[summaryIndex(as.Date(dt))])
}

ui <- dashboardPage(
  dashboardHeader(title = "Apple Health Data", dropdownMenuOutput("notificationMenu")),

  dashboardSidebar(
    sidebarMenu(
      menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
      dateInput("date1", label="Choose Date:", value = startDate),
      menuItem("Steps Heat Map", tabName = "heatmap", badgeLabel = "new", badgeColor = "green", icon = icon("th"))
    )
  ),

  dashboardBody(
    tabItems(
      tabItem(tabName = "dashboard",
        fluidRow(
          column(8, align="center", offset = 2,
          h2(textOutput("theDate")),
          hr()
          )
        ),
        fluidRow(
          infoBoxOutput("energyBurned"),
          infoBoxOutput("exerciseTime"),
          infoBoxOutput("standHours")
        ),

        hr(),
        fluidRow(
          plotOutput("energyBurnedPlot", height="200px")
        ),
        hr(),
        fluidRow(
          plotOutput("exerciseTimePlot", height="200px")
        ),
        hr(),
        fluidRow(
          plotOutput("standHoursPlot", height="200px")
        )
      ),
      tabItem(tabName = "heatmap",
        fluidRow(
          column(8, align="center", offset = 2,
                 h2("Steps Heat Map"),
                 hr()
          )
        ),
        fluidRow(
          plotOutput("heatmapPlot")
        )
      )
    )
  )
)

server <- function(input, output) {
  label <- function(which) {
    return (paste0(lastSummaryValue(which, input$date1), "/", lastSummaryValue(paste0(which, "Goal"), input$date1)))
  }

  output$theDate <- renderText({
    format(input$date1, "%A, %B %d, %Y")
  })

  output$energyBurned <- renderInfoBox({
    infoBox(
      "MOVE", paste0(label("activeEnergyBurned"), " kcal"), icon = icon("road", lib = "glyphicon"),
      color = "red", fill=TRUE
    )
  })
  output$exerciseTime <- renderInfoBox({
    infoBox(
      "EXERCISE", paste0(label("appleExerciseTime"), " min"), icon = icon("heart", lib = "glyphicon"),
      color = "green", fill=TRUE
    )
  })
  output$standHours <- renderInfoBox({
    infoBox(
      "STAND", paste0(label("appleStandHours"), " hr"), icon = icon("arrow-up", lib = "glyphicon"),
      color = "blue", fill=TRUE
    )
  })

  output$energyBurnedPlot <- renderPlot({
    df$summary %>%
      group_by(period) %>%
      summarize(calories=mean(activeEnergyBurned), goal=round(mean(activeEnergyBurnedGoal))) %>%
      ggplot(aes(x=period, y=calories)) +
      ggtitle("Active Energy Burned / Day") +
      theme_hc() + scale_colour_hc() +
      geom_bar(stat='identity', width=0.15, fill="red", color="red") +
      geom_point(aes(x=period, y=goal)) +
      geom_text(aes(y=goal, label=paste0("   ", goal), hjust=0))
  })

  output$exerciseTimePlot <- renderPlot({
    df$summary %>%
      group_by(period) %>%
      summarize(time=mean(appleExerciseTime), goal=round(mean(appleExerciseTimeGoal))) %>%
      ggplot(aes(x=period, y=time)) +
      ggtitle("Exercise Time / Day") +
      theme_hc() + scale_colour_hc() +
      geom_bar(stat='identity', width=0.15, fill="green", color="green") +
      geom_point(aes(x=period, y=goal)) +
      geom_text(aes(y=goal, label=paste0("   ", goal), hjust=0))
  })

  output$standHoursPlot <- renderPlot({
    df$summary %>%
      group_by(period) %>%
      summarize(hours=mean(appleStandHours), goal=round(mean(appleStandHoursGoal))) %>%
      ggplot(aes(x=period, y=hours)) +
      ggtitle("Stand Hours / Day") +
      theme_hc() + scale_colour_hc() +
      geom_bar(stat='identity', width=0.15, fill="blue", color="blue") +
      geom_point(aes(x=period, y=goal)) +
      geom_text(aes(y=goal, label=paste0("   ", goal), hjust=0))
  })

  output$heatmapPlot <- renderPlot({
    #heatmap day of week hour of day
    df$steps %>%
      group_by(date,dayofweek,hour) %>%
      summarize(steps=sum(value)) %>%
      group_by(hour,dayofweek) %>%
      summarize(steps=sum(steps)) %>%
      arrange(desc(steps)) %>%
      ggplot(aes(x=dayofweek, y=hour, fill=steps)) +
      geom_tile() +
      scale_fill_continuous(labels = scales::comma, low = 'white', high = 'red') +
      theme_bw() +
      theme(panel.grid.major = element_blank())
  })

  output$notificationMenu <- renderMenu({
    dropdownMenu(type = "notifications",
      notificationItem(
        text = "3 new health data messages",
        icon("users")
      ),
      notificationItem(
        text = "Move - 50% past goal!",
        icon("heart", lib = "glyphicon"),
        status = "success"
      ),
      notificationItem(
        text = "Stand - 12% past goal!",
        icon("star"),
        status = "success"
      ),
      notificationItem(
        text = "Exercise - 90% of goal",
        icon = icon("exclamation-triangle"),
        status = "warning"
      )
    )
  })
}

lastSummaryValue <- function(which, dt) {
  a <- df$summary[[which]]
  return(round(a[summaryIndex(dt)]))
}

shinyApp(ui = ui, server = server)