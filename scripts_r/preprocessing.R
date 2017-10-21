library(tidyr)
library(dplyr)

data=read.csv('data/binned_word_count_0y11m_2y0m.txt',header=T, encoding="UTF-8", stringsAsFactors=FALSE)

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

plot.type = c("rel.freq","cumu.freq","wordcount","cumu.count")
plot.ylab = c("Counts by age (per 1000 words)\n",
              "Cumulative counts (per 1000 words)\n",
              "Counts by age (not normalized)\n",
              "Cumulative counts (not normalized)\n")
output.details = data.frame(plot.type = plot.type, plot.ylab = plot.ylab)
