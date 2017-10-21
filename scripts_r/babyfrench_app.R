library(shiny)
library(tidyr)
library(dplyr)
library(ggplot2)

source('scripts_r/preprocessing.R')

ui = fluidPage(
  textInput(inputId = 'whichword',
            label = "Select a word",
            value = 'le'),
  selectInput("outputplot", "Type:",
              c("Freq. per month" = "rel.freq",
                "Cumulative freq." = "cumu.freq",
                "Counts per month" = "wordcount",
                "Cumulative counts" = "cumu.count")),
  plotOutput('plot')
)
server = function(input, output) {
  output$plot = renderPlot({
    if (!is.null(input$outputplot)) {
      column = input$outputplot
    }
    ggplot(subset(data.normalized, word == input$whichword), aes_string(x='age',y=column))+geom_point()
    })
}
shinyApp(ui=ui, server=server)

