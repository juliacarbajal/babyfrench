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
ui = navbarPage(
       title = "BabyFrench Word Database",
       theme = shinytheme("united"),
       tabPanel(
         'Word frequencies',
         h1('Word Frequencies'),
         hr(),
         div(p('This database contains word frequencies calculated over a compilation of French CHILDES corpora.
         The compiled corpus is composed of speech transcripts from adults speaking to or near a child.\n
         Age range of children included in these corpora: 11m - 24m.'),
             p('To search the database, type one or more French words (separated by commas).')),
         br(),
         fluidRow(
           column(3,
              textInput(inputId = 'wordselect',
                        label = "Type word(s) to search:",
                        value = 'maman,bébé'),
              selectInput("outputplot", "Output measure:",
                          c("Freq. per month"   = "rel.freq",
                            "Cumulative freq."  = "cumu.freq",
                            "Counts per month"  = "wordcount",
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
    whichwords = gsub(' ','',input$wordselect)
    whichwords = strsplit(whichwords,',')[[1]]
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

