# Install if needed
install.packages("stm")
install.packages("tm")
install.packages("textclean")
install.packages("tidyverse")
install.packages("quanteda")

# Load packages
library(stm)
library(tm)
library(tidyverse)
library(textclean)
library(quanteda)
library(readr)

#Load in complete merged dataset
all_Public_reviews_sentiment <- read_csv("all_Public_reviews_sentiment_2.csv")
 
data <- all_Public_reviews_sentiment


### Descriptive Analysis #####

# Apply new dataset name
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


### STM preperation ####


data$sentiment_label <- as.factor(data$sentiment_label)
levels(data$sentiment_label)

# Step 1: Convert raw text reviews into a format suitable for topic modeling (document-term matrix).
processed <- textProcessor(documents = data$review_translated,
                           metadata = data,
                           lowercase = TRUE,              # Convert all text to lowercase
                           removestopwords = TRUE,         # Remove common words like 'the', 'and'
                           removenumbers = TRUE,           # Remove numeric characters
                           removepunctuation = TRUE,       # Remove punctuation
                           wordLengths = c(3, Inf),        # Keep words of 3+ characters
                           stem = FALSE)                   # Do not apply stemming (preserve word form)


# Step 2: Final preprocessing step to format documents, vocabulary, and metadata for STM.
out <- prepDocuments(processed$documents, processed$vocab, processed$meta)

# Step 3: Assign the processed components to variables used in modeling
docs <- out$documents
vocab <- out$vocab
meta <- out$meta

# Step 4: Train the STM model with 10 topics and sentiment as a covariate influencing topic prevalence.
model <- stm(documents = docs,
             vocab = vocab,
             data = meta,
             K = 10,  # You can change this number based on coherence
             prevalence = ~ sentiment_label,
             max.em.its = 75,
             init.type = "Spectral")

effect <- estimateEffect(1:10 ~ sentiment_label, model, meta = meta)




#### Topic Proportions ######

# Step 1: Extract the document-topic distribution matrix (θ matrix)
theta <- model$theta  # Rows = documents, Columns = topics

# Step 2: Calculate average topic proportions (mean over all documents)
topic_proportions <- colMeans(theta)  # Average over all documents

# Step 3: Add topic labels 
topic_labels <- c(
  "Account Setup & Identification",
  "Fraud & Security Concerns",
  "Ease of Use & App Functionality",
  "Login & App Technical Issues",
  "Card Usage & Payments",
  "Positive Sentiment & Satisfaction",
  "Identity Verification & KYC Frustrations",
  "Errors & Failed Attempts",
  "Currency Exchange & Crypto",
  "Customer Support Problems"
)

# Step 4: Create a data frame with the topic proportions and labels
topic_df <- data.frame(
  Topic = paste0("Topic ", 1:10),
  Label = topic_labels,
  Proportion = topic_proportions
)

# Step 5: Sort the topics by their average proportion (optional)
topic_df <- topic_df[order(-topic_df$Proportion), ]

# Step 6: Visualize the topic proportions using a bar plot
library(ggplot2)

ggplot(topic_df, aes(x = reorder(Label, Proportion), y = Proportion)) +
  geom_col(fill = "steelblue") +
  coord_flip() +
  labs(
    title = "Average Topic Proportions Across All Reviews",
    x = "Topic",
    y = "Average Proportion"
  ) +
  theme_minimal()



###### Sentiment as covariate  ########


# Step 1: Plot how each topic differs between positive and negative reviews
plot(effect, covariate = "sentiment_label", 
     topics = 1:10, 
     model = model,
     method = "difference",
     cov.value1 = "positive",  
     cov.value2 = "negative",  # Reference group
     xlab = "Effect of Positive Sentiment on Topic Prevalence")

labelTopics(model, n = 10)  # Show top 10 words per topic

# Step 2: Define custom topic labels
custom_labels <- c(
  "Topic 1: Account Setup & Identification",
  "Topic 2: Fraud & Security Concerns",
  "Topic 3: Ease of Use & App Functionality",
  "Topic 4: Login & App Technical Issues",
  "Topic 5: Card Usage & Payments",
  "Topic 6: Positive Sentiment & Satisfaction",
  "Topic 7: Identity Verification & KYC Frustrations",
  "Topic 8: Curreny Exchange & Crypto",
  "Topic 9: Errors & Failed Attempts",
  "Topic 10: Customer Support Problems"
)

# Step 3: Save a high-resolution plot with custom topic labels
png("topic_modelling_labeled.png", width = 2000, height = 900, res = 150)

par(mar = c(5, 16, 4, 2))  # Add more left margin to fit long labels

plot(effect,
     covariate = "sentiment_label",
     topics = 1:10,
     model = model,
     method = "difference",
     cov.value1 = "positive",
     cov.value2 = "negative",
     xlab = "Effect of Positive Sentiment on Topic Prevalence",
     labeltype = "custom",
     custom.labels = custom_labels)

dev.off()


##### EXACT EXACT SENTIMENT EFFECTS ######

# Loop through each topic to extract estimated sentiment effects with confidence intervals
results_list <- list()


for (i in 1:10) {
  # Extract summary for the i-th topic
  summ <- summary(effect, topics = i)
  
  # Extract values for sentiment_labelpositive
  est <- summ$tables[[1]]["sentiment_labelpositive", ]
  
  # Create a data frame row
  row <- data.frame(
    Topic = i,
    Estimate = est["Estimate"],
    StdError = est["Std. Error"],
    CI_Lower = est["CI Lower"],
    CI_Upper = est["CI Upper"]
  )
  
  # Append to results list
  results_list[[i]] <- row
}

# Combine all rows into a single data frame
effect_df <- do.call(rbind, results_list)

# Add custom labels 
effect_df$Label <- c(
  "Account Setup & Identification",
  "Fraud & Security Concerns",
  "Ease of Use & App Functionality",
  "Login & App Technical Issues",
  "Card Usage & Payments",
  "Positive Sentiment & Satisfaction",
  "Identity Verification & KYC Frustrations",
  "Currency Exchange & Crypto",
  "Errors & Failed Attempts",
  "Customer Support Problems"
)

# sort by Estimate
effect_df <- effect_df[order(-effect_df$Estimate), ]

# View results
print(effect_df)



########### Correlational analysis ############
theta <- model$theta
cor_matrix <- cor(theta, use = "pairwise.complete.obs")

library(corrplot)
corrplot(cor_matrix, method = "circle", type = "upper", 
         tl.col = "black", tl.cex = 0.8, number.cex = 0.7,
         title = "Topic Correlations")
