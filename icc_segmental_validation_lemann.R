
library(dplyr)
library(stringr)
library(tidyr)
library(psych)


# ---------------------- Lemann ---------------
df <- read.csv("Inputs/Intermediates/validation_lemann_segmental_filtered.csv")

# ---- Overall ICC across all segments ----
df_wide_all <- df %>%
  pivot_wider(names_from = scorerEmail,
              values_from = segmentIndex)

# Drop the first column (IDs), keep only numeric ratings
icc_all <- psych::ICC(df_wide_all[,-1])

# Extract the ICC2 (average, absolute agreement)
all_segments_icc_val_lemann_res <- data.frame(
  ICC = icc_all$results$ICC[2],
  CI95 = paste0("[", round(icc_all$results$lower[2],3),
                " ", round(icc_all$results$upper[2],3), "]")
)


# ---- Per-segment ICCs ----
segments <- c("Stomach", "Duodenum", "Jejunum", "Ileum",  
              "Terminal ileum", "Caecum", "Ascending colon", "Transverse colon", 
              "Descending colon", "Sigmoid colon", "Rectum")

per_segment_val_lemann <- data.frame(
  Segment = segments,
  ICC = NA_real_,
  CI95 = NA_character_,
  stringsAsFactors = FALSE
)

for (seg in segments) {
  df_segment <- df %>% filter(str_detect(patient_scan_segment, seg))
  
  if (length(unique(df_segment$segmentIndex)) < 2) {
    per_segment_val_lemann[per_segment_val_lemann$Segment == seg, "ICC"] <- NA
    per_segment_val_lemann[per_segment_val_lemann$Segment == seg, "CI95"] <- 
      paste0("[all scores = ", unique(df_segment$segmentIndex), "]")
  } else {
    df_wide <- df_segment %>%
      pivot_wider(names_from = scorerEmail,
                  values_from = segmentIndex)
    
    icc_res <- psych::ICC(df_wide[,-1])
    
    per_segment_val_lemann[per_segment_val_lemann$Segment == seg, "ICC"] <- icc_res$results$ICC[2]
    per_segment_val_lemann[per_segment_val_lemann$Segment == seg, "CI95"] <- 
      paste0("[", round(icc_res$results$lower[2],3),
             " ", round(icc_res$results$upper[2],3), "]")
  }
}

print("ICC among segmental scores by segment - Validation lemann:")
print(per_segment_val_lemann)

# ---- Export to CSV ----
write.csv(all_segments_icc_val_lemann_res, "Inputs/Intermediates/icc_all_segments_validation_lemann.csv", row.names = FALSE)
write.csv(per_segment_val_lemann, "Inputs/Intermediates/icc_per_segment_validation_lemann.csv", row.names = FALSE)


