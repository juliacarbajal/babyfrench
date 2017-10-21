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
    # Separate input words
    whichwords = strsplit(input$whichword,',')[[1]]
    # Plot
    ylabel = subset(output.details,plot.type == input$outputplot)$plot.ylab
    ggplot(subset(data.normalized, word %in% whichwords), aes_string(x='age', y=input$outputplot, color='word', shape='word')) +
      geom_point(size=3)  +
      xlab('Age (months)') +
      ylab(ylabel) +
      theme(text = element_text(size=20))
  })
}

shinyApp(ui=ui, server=server)

