library(shiny)
library(tidyr)
library(dplyr)
library(ggplot2)

source('scripts_r/preprocessing.R')

ui = fluidPage(
  textInput(inputId = 'whichword',
            label = "Select a word",
            value = 'le'),
  plotOutput('hist')
)
server = function(input, output) {
  output$hist = renderPlot({
    ggplot(subset(data.normalized, word == input$whichword), aes(x=age,y=rel.freq))+geom_point()
    })
}
shinyApp(ui=ui, server=server)

