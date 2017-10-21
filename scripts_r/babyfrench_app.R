library(shiny)
library(tidyr)
library(dplyr)
library(ggplot2)

source('scripts_r/preprocessing.R')

# User Interface
ui = fluidPage(
  textInput(inputId = 'whichword',
            label = "Select a word",
            value = 'maman'),
  selectInput("outputplot", "Type:",
              c("Freq. per month" = "rel.freq",
                "Cumulative freq." = "cumu.freq",
                "Counts per month" = "wordcount",
                "Cumulative counts" = "cumu.count")),
  plotOutput('plot')
)

# Server
server = function(input, output) {
  output$plot = renderPlot({
    # Note: replace this with a table with
    # the correct ylabel for each plot type
    if (input$outputplot == 'rel.freq') {
      ytitle = 'Counts per 1000 words'
    } else {
      ytitle = input$outputplot
    }
    # Plot
    ggplot(subset(data.normalized, word == input$whichword), aes_string(x='age', y=input$outputplot)) +
      geom_point(size=2)  +
      xlab('Age (months)') +
      ylab(ytitle) +
      theme(text = element_text(size=20))
  })
}

shinyApp(ui=ui, server=server)

