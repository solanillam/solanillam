## Mariana Solanilla
## The purpose behind this R script is to perform data munging (cleaning and transforming the dataset), 
## followed by data exploration, visualization, and aggregation to extract valuable insights.
#------------------------------------------------------

# Step 1: Load Data and Clean (Munge) Data


# Load necessary libraries
library(tidyverse)
library(lubridate)
library(readxl)
library(stringr)

# Load the dataset from the specified path
df <- read_excel("~/git_repos/solanillam/Project_2/Raw_Data/Copy of df_overall_final_V1.xlsx")

# Remove 'aud', 'obs', and 'turnaround' columns from the dataset
df_cleaned <- df %>%
  select(-aud, -obs, -turnaround)

# Check the cleaned data
head(df_cleaned)

# Keep only rows where 'inc' is not 0 or NA
df_cleaned <- df_cleaned %>%
  filter(!is.na(inc) & inc != 0)%>%
  filter(!is.na(ovt))


# Step 6: Check for duplicates
df_cleaned <- df_cleaned %>%
  distinct()  # Remove duplicate rows

# Step 7: Handle outliers (e.g., overtime should not be negative or unrealistically large)
df_cleaned <- df_cleaned %>%
  filter(ovt >= 0 & ovt <= 24)  # Filter out rows where overtime is negative or larger than a reasonable limit (e.g., 24 hours)

# Step 8: Standardize text data (remove extra spaces and convert text to consistent format)
df_cleaned$unit <- trimws(toupper(df_cleaned$unit))  # Remove spaces and convert all unit names to uppercase

# Step 9: Create new columns (e.g., total work time)
df_cleaned <- df_cleaned %>%
  mutate(total_work_time = hrs + ovt)

# Check the cleaned data
head(df_cleaned)




# Time-Based Trend: Total Work Time Over Time
# Plot total work time over time
ggplot(df_cleaned, aes(x = date, y = total_work_time)) +
  geom_line(color = "blue") +
  labs(title = "Total Work Time Over Time", x = "Date", y = "Total Work Time (hrs)") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))




# Incident Distribution Across Units
# Bar plot of incidents across units
ggplot(df_cleaned, aes(x = unit, y = inc)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  labs(title = "Incidents Across Units", x = "Unit", y = "Number of Incidents") +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 55, hjust = 1, vjust = 1.0, size = 8)
  )


# Overtime vs. Hours Worked
# Scatter plot: Overtime vs. Hours Worked
ggplot(df_cleaned, aes(x = hrs, y = ovt)) +
  geom_point(color = "green", alpha = 0.6) +
  labs(title = "Overtime vs. Hours Worked", x = "Hours Worked", y = "Overtime (hrs)") +
  theme_minimal()


# Average total work time by unit
df_avg_work_time <- df_cleaned %>%
  group_by(unit) %>%
  summarize(avg_work_time = mean(total_work_time, na.rm = TRUE))

ggplot(df_avg_work_time, aes(x = reorder(unit, avg_work_time), y = avg_work_time)) +
  geom_bar(stat = "identity", fill = "coral") +
  labs(title = "Average Total Work Time by Unit", x = "Unit", y = "Average Work Time (hrs)") +
  theme(axis.text.x = element_text(angle = 55, hjust = 1, vjust = 1.0, size = 8)
  )+
  theme_minimal()


# Incidents over time
df_incidents_over_time <- df_cleaned %>%
  group_by(date) %>%
  summarize(total_incidents = sum(inc, na.rm = TRUE))

ggplot(df_incidents_over_time, aes(x = date, y = total_incidents)) +
  geom_line(color = "red") +
  labs(title = "Incidents Over Time", x = "Date", y = "Total Incidents") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 55, hjust = 1, vjust = 1.0, size = 8)
  )





