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

Qualtrics_survey_EN <- read_excel("Qualtrics survey EN_ING.xlsx")
 df <- read_excel("Qualtrics survey EN_ING.xlsx")

# --- Remove the first unwanted row ---
df <- df[-1, ]  # remove first row

# --- Data Cleaning ---
# Keep only people who agreed to the consent form & answered Q37 
clean_df <- df %>% filter(Q1 == "I Agree")
clean_df <- clean_df %>% filter(!is.na(Q37) & Q37 != "")



library(dplyr)
library(stringr)

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
    Q15 = str_extract(Q15, "^\\d"),    # Extract the first digit (1, 2, 3, 4, or 5)
    Q15 = as.numeric(Q15),
    Q16 = str_extract(Q16, "^\\d"),
    Q16 = as.numeric(Q16)               # Assuming Q18 is already clean or needs similar treatment
  )

# Add a random ID for each unique indivdual
set.seed(123)  # for reproducibility (optional)
clean_df <- clean_df %>%
  mutate(ResponseID = paste0("R_", sample(100000:999999, n(), replace = FALSE)))


###### Descriptive ANALYSIS #######
# Example: counting multiple selections in Q11
library(dplyr)
library(tidyr)

# Number of users per type
table(clean_df$QU)

######### Average trust scores per group #########
#user type

clean_df %>%
  group_by(QU) %>%
  summarise(
    Avg_Fintech_Trust = mean(Q15, na.rm = TRUE),
    Avg_Traditional_Trust = mean(Q16, na.rm = TRUE),
    Count = n()
  )

#age group

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


# count popularity of responses
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



# Create a new UserType column
clean_df <- clean_df %>%
  mutate(UserType = ifelse(tolower(Q37) == "yes", "Adopter", "Non-Adopter"))

# --- Cross-tabulation: Trust levels ---
# Trust in FinTech banks (Q15)
trust_crosstab <- table(clean_df$UserType, clean_df$Q15)
print("Trust in FinTech banks by User Type:")
print(trust_crosstab)

# Trust in Traditional banks (Q16)
trust_crosstab_trad <- table(clean_df$UserType, clean_df$Q16)
print("Trust in Traditional banks by User Type:")
print(trust_crosstab_trad)

# --- Visualization: Trust Levels ---
# Bar plot for FinTech trust
trust_crosstab_df <- as.data.frame(trust_crosstab)
colnames(trust_crosstab_df) <- c("UserType", "TrustLevel", "Count")

ggplot(trust_crosstab_df, aes(x = UserType, y = Count, fill = TrustLevel)) +
  geom_bar(stat = "identity", position = "stack") +
  labs(title = "Trust in FinTech Banks by User Type", x = "User Type", y = "Count") +
  theme_minimal()

# Bar plot for Traditional banks trust
trust_crosstab_trad_df <- as.data.frame(trust_crosstab_trad)
colnames(trust_crosstab_trad_df) <- c("UserType", "TrustLevel", "Count")

ggplot(trust_crosstab_trad_df, aes(x = UserType, y = Count, fill = TrustLevel)) +
  geom_bar(stat = "identity", position = "stack") +
  labs(title = "Trust in Traditional Banks by User Type", x = "User Type", y = "Count") +
  theme_minimal()

# --- Visualization: User Type Pie Chart ---
user_type_counts <- clean_df %>%
  count(QU) %>%  # <- use your original column QU to be sure
  rename(UserType = QU)

# Plot
library(ggplot2)

ggplot(user_type_counts, aes(x = "", y = n, fill = UserType)) +
  geom_col(width = 1, color = "white") +  # color for cleaner slices
  coord_polar(theta = "y") +
  labs(title = "Distribution of User Types", fill = "User Type") +
  theme_void() +
  theme(legend.title = element_text(size = 12),
        legend.text = element_text(size = 10))


# --- Word Cloud: type of bank used
# --- Word Cloud: Concerns about FinTech banks (Q18) ---
Bank_text <- tolower(paste(clean_df$Q7, collapse = " "))
Bank_words <- strsplit(Bank_text, "\\s+")[[1]]

wordcloud(Bank_words, max.words = 15, colors = brewer.pal(8, "Set1"))



######## STM MODEL ANALYSIS  ##########

# Load packages
library(stm)
library(tm)
library(SnowballC)

####### MOTIVATOR FOR FINTECH ####### 

# --- Prepare text data ---
text_data <- clean_df %>%
  select(ResponseID, 
         documents = Q12) %>%  # only your open-ended question
  filter(!is.na(documents) & documents != "")

unwanted_words <- c("revolut", "ing", "bunq", "monzo", "n26")

# Function to remove unwanted words
remove_unwanted <- function(text, words) {
  pattern <- paste0("\\b(", paste(words, collapse = "|"), ")\\b")
  str_remove_all(text, regex(pattern, ignore_case = TRUE))
}

text_data <- text_data %>%
  mutate(documents = remove_unwanted(documents, unwanted_words))

# --- Preprocess text into document-term matrix format ---
processed <- textProcessor(documents = text_data$documents,
                           metadata = text_data,
                           lowercase = TRUE,
                           removestopwords = TRUE,
                           removenumbers = TRUE,
                           removepunctuation = TRUE,
                           wordLengths = c(3, Inf),
                           stem = FALSE)

# --- Prepare documents and vocab ---
out <- prepDocuments(processed$documents, processed$vocab, processed$meta)

# Assign objects for modeling
docs <- out$documents
vocab <- out$vocab
meta <- out$meta

# --- Fit STM model WITHOUT covariates ---
model <- stm(documents = docs,
             vocab = vocab,
             K = 5,  # number of topics (you can adjust)
             max.em.its = 75,
             init.type = "Spectral")

# --- Show top words per topic ---
labelTopics(model, n = 5)

# --- Optional: Plot topics
plot(model, type = "summary", n = 5)


###### BARRIERS TO FINTECH ADOPTION #########


# --- Prepare text data ---
text_data <- clean_df %>%
  select(ResponseID, 
         documents = Q13) %>%  # only your open-ended question
  filter(!is.na(documents) & documents != "")

unwanted_words <- c("revolut", "ing", "bunq", "monzo", "n26")

# Function to remove unwanted words
remove_unwanted <- function(text, words) {
  pattern <- paste0("\\b(", paste(words, collapse = "|"), ")\\b")
  str_remove_all(text, regex(pattern, ignore_case = TRUE))
}

text_data <- text_data %>%
  mutate(documents = remove_unwanted(documents, unwanted_words))

# --- Preprocess text into document-term matrix format ---
processed <- textProcessor(documents = text_data$documents,
                           metadata = text_data,
                           lowercase = TRUE,
                           removestopwords = TRUE,
                           removenumbers = TRUE,
                           removepunctuation = TRUE,
                           wordLengths = c(3, Inf),
                           stem = FALSE)

# --- Prepare documents and vocab ---
out <- prepDocuments(processed$documents, processed$vocab, processed$meta)

# Assign objects for modeling
docs <- out$documents
vocab <- out$vocab
meta <- out$meta

# --- Fit STM model WITHOUT covariates ---
model <- stm(documents = docs,
             vocab = vocab,
             K = 5,  # number of topics (you can adjust)
             max.em.its = 75,
             init.type = "Spectral")

# --- Show top words per topic ---
labelTopics(model, n = 5)

# --- Optional: Plot topics
plot(model, type = "summary", n = 5)


###### HOW FINTECH BANKS CAN IMPROVE #####


# --- Prepare text data ---
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

# --- Preprocess text into document-term matrix format ---
processed <- textProcessor(documents = text_data$documents,
                           metadata = text_data,
                           lowercase = TRUE,
                           removestopwords = TRUE,
                           removenumbers = TRUE,
                           removepunctuation = TRUE,
                           wordLengths = c(3, Inf),
                           stem = FALSE)

# --- Prepare documents and vocab ---
out <- prepDocuments(processed$documents, processed$vocab, processed$meta)

# Assign objects for modeling
docs <- out$documents
vocab <- out$vocab
meta <- out$meta

# --- Fit STM model WITHOUT covariates ---
model <- stm(documents = docs,
             vocab = vocab,
             K = 6,  # number of topics (you can adjust)
             max.em.its = 75,
             init.type = "Spectral")

# --- Show top words per topic ---
labelTopics(model, n = 6)

# --- Optional: Plot topics
plot(model, type = "summary", n = 6)

# Step 1: Extract the document-topic distribution matrix (θ)
theta <- model$theta  # Rows = documents, columns = topics

# Step 2: Calculate the average topic proportions across all documents
topic_proportions <- colMeans(theta)

# Step 3: View the proportions
print(topic_proportions)

########## WITH COVARIATE USE TYPE  ########

# --- Load Libraries ---
library(dplyr)
library(stringr)
library(stm)

# --- Step 1: Prepare Text Data ---
text_data <- clean_df %>%
  select(ResponseID, 
         documents = Q18,         # Open-ended question (adjust if needed)
         UserType = QU) %>%      # <-- ADD User Type now
  filter(!is.na(documents) & documents != "",
         !is.na(UserType))        # Make sure UserType is available

# --- Step 2: Clean UserType and documents ---
# Make sure UserType is a factor (important for STM)
text_data <- text_data %>%
  mutate(UserType = as.factor(UserType))

# Remove specific words like Revolut, ING, etc.
unwanted_words <- c("revolut", "ing", "bunq", "monzo", "n26")

remove_unwanted <- function(text, words) {
  pattern <- paste0("\\b(", paste(words, collapse = "|"), ")\\b")
  str_remove_all(text, regex(pattern, ignore_case = TRUE))
}

text_data <- text_data %>%
  mutate(documents = remove_unwanted(documents, unwanted_words))

# --- Step 3: Preprocess Text into DTM format ---
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

# --- Step 4: Fit STM Model WITH Covariate (User Type) ---
model <- stm(documents = docs,
             vocab = vocab,
             data = meta,
             prevalence = ~ UserType,  # <-- Use User Type as covariate now
             K = 6,  # Number of topics (adjust if needed)
             max.em.its = 75,
             init.type = "Spectral")

# --- Step 5: Explore Topics ---
labelTopics(model, n = 6)

# --- Optional: Plot topics
plot(model, type = "summary", n = 6)

# Extract topic proportions
theta <- model$theta  # Rows = documents, Columns = topics

# Add UserType info back
theta_df <- as.data.frame(theta)
theta_df$UserType <- meta$UserType

library(dplyr)

# Average topic proportion per group
topic_means <- theta_df %>%
  group_by(UserType) %>%
  summarise(across(starts_with("V"), mean, na.rm = TRUE))


