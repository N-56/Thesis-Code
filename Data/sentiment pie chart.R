all_Public_reviews_sentiment <- read_csv("all_Public_reviews_sentiment_2.csv")

my_data<- all_Public_reviews_sentiment

# Count the frequency of each sentiment
sentiment_counts <- table(my_data$sentiment_label)

# Calculate percentages
sentiment_percentages <- round(100 * sentiment_counts / sum(sentiment_counts), 1)

# Create labels with sentiment and percentage
labels <- paste(names(sentiment_counts), "-", sentiment_percentages, "%")

# Plot pie chart with percentages
pie(sentiment_counts,
    main = "Sentiment Distribution",
    col = c("lightgreen", "salmon"),
    labels = labels,
    clockwise = TRUE)

install.packages("tm")          # Text mining tools
install.packages("wordcloud")   # Basic word cloud
install.packages("RColorBrewer")# Nice colors
install.packages("wordcloud2")  # Fancy interactive word clouds

library(tm)
library(wordcloud)
library(RColorBrewer)
library(wordcloud2)

# Create a corpus from your text column
corpus <- Corpus(VectorSource(data$text))

# Clean the text
corpus <- corpus %>%
  tm_map(content_transformer(tolower)) %>%
  tm_map(removePunctuation) %>%
  tm_map(removeNumbers) %>%
  tm_map(removeWords, stopwords("english")) %>%
  tm_map(stripWhitespace)

# Create Term-Document Matrix
tdm <- TermDocumentMatrix(corpus)
m <- as.matrix(tdm)
word_freqs <- sort(rowSums(m), decreasing = TRUE)
df <- data.frame(word = names(word_freqs), freq = word_freqs)

