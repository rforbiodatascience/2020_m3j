# Clear workspace
# ------------------------------------------------------------------------------
rm(list = ls())

# Load libraries
# ------------------------------------------------------------------------------
library("dplyr")
library("tidyverse")


# Define functions
# ------------------------------------------------------------------------------
source(file = "R/99_project_functions.R")

# Load data
# ------------------------------------------------------------------------------
my_url <- "https://www.ncbi.nlm.nih.gov/Class/FieldGuide/BLOSUM62.txt"
bl62 <- read_table(file = my_url, comment = '#') %>%
  rename(aa = X1) %>% 
  write_tsv(path = "data/_raw/my_raw_data.tsv")


my_data_raw <- read_tsv(file = "data/_raw/my_raw_data.tsv")

# Wrangle data
# ------------------------------------------------------------------------------
my_data <- my_data_raw # %>% 


# Write data
# ------------------------------------------------------------------------------
write_tsv(x = my_data,
          path = "data/01_my_data.tsv")