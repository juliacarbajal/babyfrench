library(shiny)
library(tidyr)
library(dplyr)
library(ggplot2)

setwd("C:/Users/Julia/Documents/01 - Projects/01 - LSCP/02 - Assimilation/01 - Corpus/Test folder/")
data=read.csv('binned_word_count_0y11m_2y0m.txt',header=T, encoding="UTF-8", stringsAsFactors=FALSE)

# Transform data to long format with age column
data.long = gather(data, age, wordcount, m.11:m.24, factor_key=TRUE)
data.long$age = gsub('m.','',paste(data.long$age))
data.long$age = as.numeric(data.long$age)

data.total = data.long %>%
  group_by(age) %>%
  summarise(total.count = sum(wordcount)) %>%
  ungroup()

data.normalized = merge(data.long,data.total) %>%
  mutate(rel.freq = 1000*wordcount/total.count) %>% # Relative frequency per 1000 words
  group_by(word) %>%
  mutate(cumu.count = cumsum(wordcount), cumu.freq = 1000*cumu.count/cumsum(total.count)) %>%
  ungroup()


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

