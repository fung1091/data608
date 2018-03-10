library('shiny')
library('ggplot2')

data <- read.csv("https://raw.githubusercontent.com/fung1091/data608/master/module3/cleaned-cdc-mortality-1999-2010-2.csv")

data2010 <- data[data$Year == 2010,]


shinyServer(
  function(input, output) {
    
    cause1 <- reactive({
      df <- subset(data2010, data2010$ICD.Chapter==input$cause_name)
      df$State <- reorder(df$State, 1/df$Crude.Rate)
      df
    })
    
    output$plotcauses <- renderPlot({
      ggplot(cause1(), aes(x=State, y=Crude.Rate, colour = Crude.Rate)) + 
        geom_point(stat="identity", position=position_dodge(), size=5) +
        coord_flip() + 
        geom_text(aes(x= State, y=0, ymax = Crude.Rate,
                      label = State, hjust = 1, vjust = 0.25)) + 
        scale_x_discrete(breaks = NULL) +
        ylab("Crude Rate") + 
        theme(axis.text.y = element_text(angle = 200, size=8, vjust = 0.35))
      
      
    })
    
  }
)