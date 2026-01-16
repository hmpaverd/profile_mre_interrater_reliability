# profile_mre_interrater_reliability
This repository contains the analysis code used to evaluate the agreement between radiologists scoring Magnetic Resonance Enterography (MRE) scans in the PROFILE clinical trial.

## Project Overview
We assess the reproducibility of two major scoring systems:
* **MaRIA:** Magnetic Resonance Index of Activity
* **Lemann Index ** 

## Methods
* **Statistical Metrics:** Intraclass Correlation Coefficient (ICC), Fleiss's kappa
* **Sample Size:** Central pool of 5 radiologists scoring 79 scans across three rounds
* **Tools Used:** Python (pandas, pingouin, krippendorff), R (psych)
* **Analysis Levels:** Agreement is evaluated globally, per segment, by radiological feature, and across categorical cut-offs.
