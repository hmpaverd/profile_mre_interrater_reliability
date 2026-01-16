
library(psych)
library(dplyr)
library(tidyr)

# ---------------------- MARIA-S ---------------

file_path <- "Inputs/Intermediates/validation_maria_global_filtered.csv" 
df <- read.csv(file_path)

df_wide <- df %>%
  select(scan, scorerEmail, mariaS) %>% # Select only the necessary columns
  pivot_wider(
    names_from = scorerEmail, # Create new columns from the scorer emails
    values_from = mariaS      # Fill those columns with the mariaS scores
  )

ratings_only <- df_wide %>%
  select(-scan)

print(ratings_only)

icc_results_marias <- ICC(ratings_only)

cat("ICC Results from the 'psych' package:\n")
print(icc_results_marias)

write.csv(icc_results_marias$results, "Inputs/Intermediates/icc_global_validation_marias.csv")

# ---------------------- MARIAs-E ---------------

file_path <- "Inputs/Intermediates/validation_maria_global_filtered.csv" 
df <- read.csv(file_path)

df_wide <- df %>%
  select(scan, scorerEmail, mariaE) %>% # Select only the necessary columns
  pivot_wider(
    names_from = scorerEmail, # Create new columns from the scorer emails
    values_from = mariaE      # Fill those columns with the mariaS scores
  )

ratings_only <- df_wide %>%
  select(-scan)

print(ratings_only)

icc_results_mariae <- ICC(ratings_only)

cat("ICC Results from the 'psych' package:\n")
print(icc_results_mariae)

# export to csv
write.csv(icc_results_mariae$results, "Inputs/Intermediates/icc_global_validation_mariae.csv")

# ---------------------- Lemann ---------------

file_path <- "Inputs/Intermediates/validation_lemann_global_filtered.csv" 
df <- read.csv(file_path)

df_wide <- df %>%
  select(scan, scorerEmail, lemannIndex) %>% # Select only the necessary columns
  pivot_wider(
    names_from = scorerEmail, # Create new columns from the scorer emails
    values_from = lemannIndex      # Fill those columns with the mariaS scores
  )

ratings_only <- df_wide %>%
  select(-scan)

print(ratings_only)

icc_results_lemann <- ICC(ratings_only)

cat("ICC Results from the 'psych' package:\n")
print(icc_results_lemann)

write.csv(icc_results_lemann$results, "Inputs/Intermediates/icc_global_validation_lemann.csv")