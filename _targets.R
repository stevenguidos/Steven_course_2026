library(targets)
library(tarchetypes)

# Load your cleaning function
source("R/functions.R")

# Define the workflow
list(
  
  # Step 1: Locate the raw dataset
  tar_target(
    raw_file,
    "data/penguins.csv",
    format = "file"
  ),
  
  # Step 2: Read the dataset
  tar_target(
    raw_data,
    read.csv(raw_file)
  ),
  
  # Step 3: Clean the dataset
  tar_target(
    clean_data,
    clean_penguins(raw_data)
  ),
  
  # Step 4: Generate the report
  tar_quarto(
    report,
    path = "reports/penguins.qmd"
  )
  
)


