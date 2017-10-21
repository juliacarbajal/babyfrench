library(shiny)
library(shinythemes)
library(tidyr)
library(dplyr)
library(ggplot2)
library(extrafont)

source('scripts_r/preprocessing.R')

font_import(pattern="[U/u]buntu")
loadfonts(device="win")

# User Interface
ui = navbarPage(title = "BabyFrench Word Database",
                theme = shinytheme("united"),
  tabPanel('Word frequencies',
  br(),
  fluidRow(
    column(3,
           textInput(inputId = 'wordselect',
                     label = "Type word(s) to search:",
                     value = 'maman'),
           selectInput("outputplot", "Output measure:",
                       c("Freq. per month" = "rel.freq",
                         "Cumulative freq." = "cumu.freq",
                         "Counts per month" = "wordcount",
                         "Cumulative counts" = "cumu.count")),
           actionButton(inputId = "go",
                        label = "Search!")
           ),
    column(9, plotOutput('plot'))
  )
  )
)

# Server
server = function(input, output) {
  wordlist = eventReactive(input$go, {
    whichwords = strsplit(input$wordselect,',')[[1]]
  })
  output$plot = renderPlot({
    # Separate input words
    # Plot
    loadfonts(device="win")
    ylabel = subset(output.details,plot.type == input$outputplot)$plot.ylab
    ggplot(subset(data.normalized, word %in% wordlist()),
           aes_string(x='age', y=input$outputplot, color='word', shape='word')) +
      geom_point(size=3)  +
      xlim(min(data.normalized$age)-1,max(data.normalized$age)+1) +
      xlab('Age (months)') +
      ylab(ylabel) +
      theme(text = element_text(size=20, family="Ubuntu"))
  })
}

shinyApp(ui=ui, server=server)

