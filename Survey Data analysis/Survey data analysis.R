# --- Load libraries ---
library(dplyr)
library(ggplot2)
library(tidyr)
library(readr)
library(wordcloud)
library(RColorBrewer)
library(stm)
library(tm)
library(SnowballC)
library(stringr)

#### PREPARE DATASET ####
Qualtrics_survey_EN <- read_excel("Qualtrics survey EN_ING.xlsx")
 df <- read_excel("Qualtrics survey EN_ING.xlsx")

# Remove the first unwanted row 
df <- df[-1, ]  

# Data Cleaning 
# Keep only people who agreed to the consent form & answered Q37 
clean_df <- df %>% filter(Q1 == "I Agree")
clean_df <- clean_df %>% filter(!is.na(Q37) & Q37 != "")


clean_df <- clean_df %>%
  mutate(Q9 = ifelse(str_detect(Q9, "Other \\(Please Specify\\)"),
                     ifelse(!is.na(Q9_8_TEXT) & Q9_8_TEXT != "",
                            str_replace(Q9, "Other \\(Please Specify\\)", Q9_8_TEXT),
                            str_replace(Q9, ",?\\s*Other \\(Please Specify\\)", "")),
                     Q9))

clean_df <- clean_df %>%
  mutate(Q14 = ifelse(str_detect(Q14, "Other \\(Please specify\\)"),
                     ifelse(!is.na(Q14_6_TEXT) & Q14_6_TEXT != "",
                            str_replace(Q14, "Other \\(Please specify\\)", Q14_6_TEXT),
                            str_replace(Q14, ",?\\s*Other \\(Please specify\\)", "")),
                     Q14))

### cleaning up and turning into numeric
clean_df <- clean_df %>%
  mutate(
    Q15 = str_extract(Q15, "^\\d"),    
    Q15 = as.numeric(Q15),
    Q16 = str_extract(Q16, "^\\d"),
    Q16 = as.numeric(Q16)               
  )

# Add a random ID for each unique indivdual
set.seed(123)  
clean_df <- clean_df %>%
  mutate(ResponseID = paste0("R_", sample(100000:999999, n(), replace = FALSE)))


###### Descriptive ANALYSIS #######

# Number of users per type
table(clean_df$QU)

######### Average trust scores per group #########

#User type

clean_df %>%
  group_by(QU) %>%
  summarise(
    Avg_Fintech_Trust = mean(Q15, na.rm = TRUE),
    Avg_Traditional_Trust = mean(Q16, na.rm = TRUE),
    Count = n()
  )

#Age group

clean_df %>%
  group_by(Q2) %>%
  summarise(
    Avg_Fintech_Trust = mean(Q15, na.rm = TRUE),
    Avg_Traditional_Trust = mean(Q16, na.rm = TRUE),
    Count = n()
  )


# Summarize FinTech trust
fintech_trust_by_user <- clean_df %>%
  group_by(QU) %>%
  summarise(Avg_Fintech_Trust = mean(Q15, na.rm = TRUE))

# Bar plot
ggplot(fintech_trust_by_user, aes(x = QU, y = Avg_Fintech_Trust, fill = QU)) +
  geom_bar(stat = "identity") +
  labs(title = "Average Trust in FinTech Banks by User Type",
       x = "User Type",
       y = "Average Trust (1–5)") +
  theme_minimal() +
  theme(legend.position = "none")



# FinTech Trust ANOVA
fintech_aov <- aov(Q15 ~ QU, data = clean_df)
summary(fintech_aov)

# Traditional Trust ANOVA
traditional_aov <- aov(Q16 ~ QU, data = clean_df)
summary(traditional_aov)


# Count popularity of responses
multi_choice_counts <- clean_df %>%
  separate_rows(Q9, sep = ",\\s*") %>%  # Split on comma + optional spaces
  group_by(Q9) %>%
  summarise(Count = n()) %>%
  arrange(desc(Count))

print(multi_choice_counts)


# Split answers into rows
multi_choice_counts <- clean_df %>%
  separate_rows(Q14, sep = ",\\s*") %>%  # Split on comma + optional spaces
  group_by(Q14) %>%
  summarise(Count = n()) %>%
  arrange(desc(Count))

print(multi_choice_counts)


# Word Cloud: type of bank used
Bank_text <- tolower(paste(clean_df$Q7, collapse = " "))
Bank_words <- strsplit(Bank_text, "\\s+")[[1]]

wordcloud(Bank_words, max.words = 15, colors = brewer.pal(8, "Set1"))

### Demographics ###

# Replace column names to match actual dataset
age_counts <- table(clean_df$Q2, useNA = "ifany")
gender_counts <- table(clean_df$Q3, useNA = "ifany")
education_counts <- table(clean_df$Q4, useNA = "ifany")
employment_counts <- table(clean_df$Q5, useNA = "ifany")
user_counts <- table(clean_df$QU, useNA = "ifany")

# Print counts
print(age_counts)
print(gender_counts)
print(education_counts)
print(employment_counts)
print(user_counts)

# Calculate percentages
total_responses <- nrow(clean_df)

age_percent <- round(100 * age_counts / total_responses, 1)
gender_percent <- round(100 * gender_counts / total_responses, 1)
education_percent <- round(100 * education_counts / total_responses, 1)
employment_percent <- round(100 * employment_counts / total_responses, 1)

# Combine into a data frame 
age_summary <- data.frame(
  Age = names(age_counts),
  Count = as.vector(age_counts),
  Percentage = as.vector(age_percent)
)

gender_summary <- data.frame(
  Gender = names(gender_counts),
  Count = as.vector(gender_counts),
  Percentage = as.vector(gender_percent)
)

employment_summary <- data.frame(
  Employment_Status = names(employment_counts),
  Count = as.vector(employment_counts),
  Percentage = as.vector(employment_percent)
)
education_summary <- data.frame(
  Education_Status = names(education_counts),
  Count = as.vector(education_counts),
  Percentage = as.vector(education_percent)
)

# View results
print(age_summary)
print(gender_summary)
print(education_summary)
print(employment_summary)



######## STM MODEL ANALYSIS  ##########

# Load packages
library(stm)
library(tm)
library(SnowballC)



###### HOW FINTECH BANKS CAN IMPROVE #####


# Prepare text data 
text_data <- clean_df %>%
  select(ResponseID, 
         documents = Q18) %>%  # only your open-ended question
  filter(!is.na(documents) & documents != "")

unwanted_words <- c("revolut", "ing", "bunq", "monzo", "n26")

# Function to remove unwanted words
remove_unwanted <- function(text, words) {
  pattern <- paste0("\\b(", paste(words, collapse = "|"), ")\\b")
  str_remove_all(text, regex(pattern, ignore_case = TRUE))
}

text_data <- text_data %>%
  mutate(documents = remove_unwanted(documents, unwanted_words))

# Preprocess text into document-term matrix format 
processed <- textProcessor(documents = text_data$documents,
                           metadata = text_data,
                           lowercase = TRUE,
                           removestopwords = TRUE,
                           removenumbers = TRUE,
                           removepunctuation = TRUE,
                           wordLengths = c(3, Inf),
                           stem = FALSE)

# Prepare documents and vocab 
out <- prepDocuments(processed$documents, processed$vocab, processed$meta)

# Assign objects for modeling
docs <- out$documents
vocab <- out$vocab
meta <- out$meta

# Fit STM model WITHOUT covariates 
model <- stm(documents = docs,
             vocab = vocab,
             K = 6,  
             max.em.its = 75,
             init.type = "Spectral")

# Show top words per topic
labelTopics(model, n = 6)

# Plot topics
plot(model, type = "summary", n = 6)

# Extract the document-topic distribution matrix (θ)
theta <- model$theta  

# Calculate the average topic proportions across all documents
topic_proportions <- colMeans(theta)

# View the proportions
print(topic_proportions)

########## WITH COVARIATE USE TYPE  ########

# Prepare Text Data 
text_data <- clean_df %>%
  select(ResponseID, 
         documents = Q18,         
         UserType = QU) %>%      
  filter(!is.na(documents) & documents != "",
         !is.na(UserType))        

# Clean UserType and documents 

text_data <- text_data %>%
  mutate(UserType = as.factor(UserType))

# Remove specific words such as Revolut, ING, etc.
unwanted_words <- c("revolut", "ing", "bunq", "monzo", "n26")

remove_unwanted <- function(text, words) {
  pattern <- paste0("\\b(", paste(words, collapse = "|"), ")\\b")
  str_remove_all(text, regex(pattern, ignore_case = TRUE))
}

text_data <- text_data %>%
  mutate(documents = remove_unwanted(documents, unwanted_words))

# Preprocess Text into DTM format 
processed <- textProcessor(documents = text_data$documents,
                           metadata = text_data,
                           lowercase = TRUE,
                           removestopwords = TRUE,
                           removenumbers = TRUE,
                           removepunctuation = TRUE,
                           wordLengths = c(3, Inf),
                           stem = FALSE)

out <- prepDocuments(processed$documents, processed$vocab, processed$meta)

# Assign objects for modeling
docs <- out$documents
vocab <- out$vocab
meta <- out$meta

# Fit STM Model WITH Covariate (User Type)
model <- stm(documents = docs,
             vocab = vocab,
             data = meta,
             prevalence = ~ UserType,  # <-- Use User Type as covariate 
             K = 6,  # Number of topics 
             max.em.its = 75,
             init.type = "Spectral")

# Explore Topics 
labelTopics(model, n = 6)

# Plot topics
plot(model, type = "summary", n = 6)

# Extract topic proportions
theta <- model$theta  

# Add UserType info back
theta_df <- as.data.frame(theta)
theta_df$UserType <- meta$UserType


# Average topic proportion per group
topic_means <- theta_df %>%
  group_by(UserType) %>%
  summarise(across(starts_with("V"), mean, na.rm = TRUE))


