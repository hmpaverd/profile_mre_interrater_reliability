library(dplyr)
library(stringr)
library(tidyr)
library(psych)


# MARIA
df <- read.csv("Inputs/Intermediates/validation_maria_segmental_filtered.csv")

# ---- Overall ICC across all segments ----
df_wide_all <- df %>%
  pivot_wider(names_from = scorerEmail,
              values_from = overallSegmentalScore)

# Drop the first column (IDs), keep only numeric ratings
icc_all <- psych::ICC(df_wide_all[,-1])

# Extract the ICC2 (average, absolute agreement)
all_segments_icc_val_maria_res <- data.frame(
  ICC = icc_all$results$ICC[2],
  CI95 = paste0("[", round(icc_all$results$lower[2],3),
                " ", round(icc_all$results$upper[2],3), "]")
)

print("Round 2 Maria:")
print(all_segments_icc_val_maria_res)

# ---- Per-segment ICCs ----
segments <- c("Stomach", "Duodenum", "Jejunum", "Ileum",  
              "Terminal ileum", "Right colon", "Transverse colon", 
              "Descending colon", "Sigmoid colon", "Rectum")

per_segment_val_maria <- data.frame(
  Segment = segments,
  ICC = NA_real_,
  CI95 = NA_character_,
  stringsAsFactors = FALSE
)

for (seg in segments) {
  df_segment <- df %>% filter(str_detect(patient_scan_segment, seg))
  
  if (length(unique(df_segment$overallSegmentalScore)) < 2) {
    per_segment_val_maria[per_segment_val_maria$Segment == seg, "ICC"] <- NA
    per_segment_val_maria[per_segment_val_maria$Segment == seg, "CI95"] <- 
      paste0("[all scores = ", unique(df_segment$overallSegmentalScore), "]")
  } else {
    df_wide <- df_segment %>%
      pivot_wider(names_from = scorerEmail,
                  values_from = overallSegmentalScore)
    
    icc_res <- psych::ICC(df_wide[,-1])
    
    per_segment_val_maria[per_segment_val_maria$Segment == seg, "ICC"] <- icc_res$results$ICC[2]
    per_segment_val_maria[per_segment_val_maria$Segment == seg, "CI95"] <- 
      paste0("[", round(icc_res$results$lower[2],3),
             " ", round(icc_res$results$upper[2],3), "]")
  }
}

# Rename Right colon → Ascending colon, and duplicate for Caecum
per_segment_val_maria$Segment[per_segment_val_maria$Segment == "Right colon"] <- "Ascending colon"
caecum_row <- per_segment_val_maria %>% filter(Segment == "Ascending colon")
caecum_row$Segment <- "Caecum"
per_segment_val_maria <- bind_rows(per_segment_val_maria, caecum_row)

print("ICC among segmental scores by segment - validation Maria:")
print(per_segment_val_maria)

# ---- Export to CSV ----
write.csv(all_segments_icc_val_maria_res, "Inputs/Intermediates/icc_all_segments_validation_maria.csv", row.names = FALSE)
write.csv(per_segment_val_maria, "Inputs/Intermediates/icc_per_segment_validation_maria.csv", row.names = FALSE)
