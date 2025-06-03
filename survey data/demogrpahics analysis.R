# Replace column names if needed to match your actual dataset
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

# Optionally, calculate percentages
total_responses <- nrow(clean_df)

age_percent <- round(100 * age_counts / total_responses, 1)
gender_percent <- round(100 * gender_counts / total_responses, 1)
education_percent <- round(100 * education_counts / total_responses, 1)
employment_percent <- round(100 * employment_counts / total_responses, 1)

# Combine into a data frame for nicer viewing
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

# View them
print(age_summary)
print(gender_summary)
print(education_summary)
print(employment_summary)
