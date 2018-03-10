#
# Data603 module 3
# Jim Lung
# 
# 
# 
# 
#

library(shiny)
library(ggplot2)
library(dplyr)

url <- paste0("https://raw.githubusercontent.com/fung1091/data608/master/module3/cleaned-cdc-mortality-1999-2010-2.csv")
mdata <- read.csv(url, stringsAsFactors = FALSE)

crude_rate <- 500000

nat_cause <- aggregate(cbind(Deaths, Population) ~ ICD.Chapter + Year, mdata, FUN = sum)
nat_cause$NatAvge <- round(nat_cause$Deaths / nat_cause$Population * crude_rate, 4)

server <- function(input, output, session) {
  sub_mdata <- reactive({subset(
    mdata, ICD.Chapter == input$causes & State == input$state_name,
    select = c(Year, Crude.Rate, ICD.Chapter)
  )})
  
  new_df <- reactive({
    df <- sub_mdata()
    colnames(df) <- c("Year", "Rate_State", "ICD.Chapter")
    merge(df, nat_cause, by=c("Year", "ICD.Chapter")) %>%
      dplyr::mutate(state_diff = lag(Rate_State) - Rate_State) %>%
      dplyr::mutate(nat_diff = lag(NatAvge) - NatAvge) %>%
      dplyr::mutate(st_nat = (state_diff - nat_diff))
  })
  
  output$causev <- renderPlot({
    ggplot(data=new_df(), aes(x=Year, y=st_nat)) + geom_line()
  })
}