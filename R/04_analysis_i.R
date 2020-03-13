# Clear workspace
# ------------------------------------------------------------------------------
rm(list = ls())

# Load libraries
# ------------------------------------------------------------------------------

# broom didn't work so tried install through tidymodels and the developer tools
# install.packages("devtools")
# devtools::install_github("tidymodels/broom") - which gave me an error message 
# I could use -  the real problem was broom::agument on a tidy version of a model 
# insted of orginial PCA model output. s 

library("tidyverse")
library("broom")
library("ggrepel")

# Define functions
# ------------------------------------------------------------------------------
source(file = "R/99_project_functions.R")

# Load data
# ------------------------------------------------------------------------------
my_data_clean_aug <- read_tsv(file = "data/03_my_data_clean_aug.tsv")

# Wrangle data
# ------------------------------------------------------------------------------
my_PCA_data <- my_data_clean_aug %>%
  select(-aa) %>% 
  PCA_performer(.) 

my_PCA_data_tidy <- my_PCA_data %>% 
  broom::tidy("pcs")  

my_PCA_aug <- my_PCA_data %>%
  broom::augment(my_data_clean_aug)

bl62_pca_aug <- my_PCA_aug  %>% 
  mutate(chem_class = get_chem_class(aa))

# Model data
# ------------------------------------------------------------------------------


cluster_data <- my_data_clean_aug %>%
  select(-aa) %>%
  kmeans(centers = 6, iter.max = 1000, nstart = 10) %>%
  augment(bl62_pca_aug)

# Visualise data
# ------------------------------------------------------------------------------

variance_explained_bar <- my_PCA_data_tidy %>% 
  ggplot(aes(x = PC, y = percent)) +
  geom_col() +
  theme_bw()

PCA_scatterplot <- bl62_pca_aug %>% 
  ggplot(aes(x = .fittedPC1, y = .fittedPC2,
             label = aa, colour = chem_class)) +
  geom_label_repel() + # library("ggrepel") trick here
  theme(legend.position = "bottom") +
  scale_colour_manual(values = c("red", "blue", "black",
                                 "purple", "green", "yellow"))

cluster_scatterplot <- cluster_data %>% 
  ggplot(aes(x = .fittedPC1, y = .fittedPC2,
             label = aa, colour = .cluster)) +
  geom_label_repel() + # library("ggrepel") trick here
  theme(legend.position = "bottom") +
  scale_colour_manual(values = c("red", "blue", "black",
                                 "purple", "green", "yellow"))
# Write data
# ------------------------------------------------------------------------------

# write_tsv(...)

ggsave(filename = "results/04_variance_explained_bar.png", variance_explained_bar)
ggsave(filename = "results/04_PCA_scatterplot.png", PCA_scatterplot)
ggsave(filename = "results/04_cluster_scatterplot.png", cluster_scatterplot)

