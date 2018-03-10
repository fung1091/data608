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


ui <- fluidPage(
  
  #Application title
  titlePanel("Mortality Improvement by State"),
  
  #Dropdown state and cause
  sidebarLayout(
    sidebarPanel(
      selectInput("state_name", "State:", choices = unique(mdata$State)),
      radioButtons("causes", "Select disease - cause of Death:",
                   unique(mdata$ICD.Chapter))
    ),
    # Show a plot of the generated distribution
    mainPanel(plotOutput("causev"))
  )
)