
library('shiny')

#Read data
url <- "https://raw.githubusercontent.com/fung1091/data608/master/module3/cleaned-cdc-mortality-1999-2010-2.csv"
data <- read.csv(url, stringsAsFactors = FALSE)
data2010 <- data[data$Year == 2010,]


cause <- unique(data2010$ICD.Chapter)
states <- unique(data2010$State)

#Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  #Application title
  titlePanel("States by Crude Mortality Rate"),
  
  #Dropdown state and cause
  sidebarLayout(
    sidebarPanel(
      selectInput("cause_name",
                   label = "Select cause of death:",
                   choices = 
                     c("Infectious & parasitic" = "Certain infectious and parasitic diseases"    ,
                       "Neoplasms" = "Neoplasms",
                       "Blood & blood-forming & immune mechanism disorders" = "Diseases of the blood and blood-forming organs and certain disorders involving the immune mechanism",
                       "Endocrine, nutritional & metabolic" = "Endocrine, nutritional and metabolic diseases",
                       "Mental & behavioural disorders" = "Mental and behavioural disorders",
                       "Nervous system" = "Diseases of the nervous system",
                       "Ear & mastoid process" = "Diseases of the ear and mastoid process",
                       "Circulatory system"  = "Diseases of the circulatory system",
                       "Respiratory system" = "Diseases of the respiratory system",
                       "Digestive system" = "Diseases of the digestive system",
                       "Skin & subcutaneous tissue" = "Diseases of the skin and subcutaneous tissue",
                       "Musculoskeletal system & connective tissue" = "Diseases of the musculoskeletal system and connective tissue",
                       "Genitourinary system" = "Diseases of the genitourinary system",
                       "Pregnancy, childbirth & the puerperium" = "Pregnancy, childbirth and the puerperium",
                       "Conditions originating in the perinatal period" = "Certain conditions originating in the perinatal period",
                       "Congenital malformations, deformations & chromosomal abnormalities" = "Congenital malformations, deformations and chromosomal abnormalities",
                       "Symptoms, signs & abnormal clinical & laboratory findings, not classified" = "Symptoms, signs and abnormal clinical and laboratory findings, not elsewhere classified",
                       "External causes of morbidity & mortality" = "External causes of morbidity and mortality"),
                   selected = 'Neoplasms'
      )
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput('plotcauses', width = "600px", height = "700px") 
    )
  )
)
)