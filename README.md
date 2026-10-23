# Penguin Analysis - R Course 2026

**Author:** Steven  
**RStudio project:** `Steven_course_2026.Rproj`

## Overview

This project explores the relationship between penguin flipper length and body mass, with observations grouped by species. It demonstrates importing a dataset, checking missing values, cleaning data with a reusable function, and producing a scatterplot in a Quarto HTML report.

The workflow combines `targets` for automation, `renv` for recording R package versions, and `here` for project-relative file paths. Git and GitHub are used to version and share the project once the repository is connected.

## Project structure

The main project files are:

```text
Steven_course_2026/
|-- Steven_course_2026.Rproj
|-- README.md
|-- _targets.R
|-- R/
|   `-- functions.R
|-- data/
|   `-- penguins.csv
`-- reports/
    |-- penguins.qmd
    `-- penguins.html       # Generated after a successful render
```

A root-level `_quarto.yml` may also contain Quarto project settings. After setting up `renv`, the project will include `renv.lock`, `.Rprofile`, and a `renv/` directory. Running the pipeline creates a local `_targets/` data store.

## Data

The analysis reads the local CSV file `data/penguins.csv`. It does not require an object named `penguins` to already exist in the RStudio Environment.

This copy of the dataset uses the following column names:

| Column | Description |
| --- | --- |
| `species` | Penguin species |
| `island` | Sampling island |
| `bill_len` | Bill length, treated as millimetres |
| `bill_dep` | Bill depth, treated as millimetres |
| `flipper_len` | Flipper length, treated as millimetres |
| `body_mass` | Body mass, treated as grams |
| `sex` | Recorded sex, including missing values |
| `year` | Observation year |

The analysis follows these measurement-unit assumptions. The CSV uses shortened names such as `body_mass` and `flipper_len`, not `body_mass_g` and `flipper_length_mm`.

**Data attribution:** Before publishing the repository, add the original dataset citation and identify the package, course material, or download source used to create this CSV. The exact source and version have not yet been documented here.

## Data cleaning

The reusable function `clean_penguins()` is saved in `R/functions.R`:

```r
clean_penguins <- function(data) {
  data |>
    dplyr::filter(
      !is.na(body_mass),
      !is.na(flipper_len)
    ) |>
    dplyr::mutate(
      body_mass_kg = body_mass / 1000
    )
}
```

The function removes rows missing either measurement needed for the figure and adds body mass in kilograms. It does not remove rows simply because another variable, such as `sex`, is missing. It does not overwrite the original CSV.

## Requirements

Use R and RStudio, with Quarto available for rendering. Git and a GitHub account are needed for the version-control part of the project, but not for running an already downloaded copy locally.

The report and pipeline use `tidyverse`, `targets`, `tarchetypes`, `quarto`, and `here`. Environment management uses `renv`. Rendering R code also requires the R Markdown/knitr tooling; see the [Quarto R guide](https://quarto.org/docs/computations/r.html).

## Reproduce the analysis

Download or clone the repository, then open `Steven_course_2026.Rproj` in RStudio. Run the following commands in the **RStudio Console from the main project folder**, not inside a report chunk.

### Restore an existing package environment

When `renv.lock` is included in the project:

```r
if (!requireNamespace("renv", quietly = TRUE)) {
  install.packages("renv")
}

renv::restore()
```

This restores the R package versions recorded in the lockfile. It does not install R or the Quarto application. See the [renv introduction](https://rstudio.github.io/renv/articles/renv.html).

When the project does not yet contain `renv.lock`, use the first-time setup section below instead.

### Build the report

Save the project scripts and Quarto document, then run:

```r
targets::tar_make()
```

The pipeline is defined in `_targets.R`. Its targets are:

| Target | Purpose |
| --- | --- |
| `raw_file` | Track `data/penguins.csv` |
| `raw_data` | Read the CSV |
| `clean_data` | Apply `clean_penguins()` |
| `report` | Render `reports/penguins.qmd` |

`tar_make()` runs the pipeline and stores target results locally. See the [targets reference](https://docs.ropensci.org/targets/reference/tar_make.html).

With the report's HTML output settings unchanged, the expected output is `reports/penguins.html`. Open it from RStudio's Files pane, or run:

```r
browseURL("reports/penguins.html")
```

### Render only the report

The step-by-step report reads the original CSV and calls the saved cleaning function itself. It does not need to begin with `tar_read(clean_data)`.

To render this version independently of the pipeline, open `reports/penguins.qmd` and click **Render**, or run from the project root:

```r
quarto::quarto_render("reports/penguins.qmd")
```

Rendering executes the document's R chunks; see the [Quarto R guide](https://quarto.org/docs/computations/r.html).

## Report contents and file paths

The report starts with the original data, then shows inspection, missing-value checks, cleaning, a scatterplot, and a summary by species. The figure uses `flipper_len` on the horizontal axis, `body_mass_kg` on the vertical axis, and colour to distinguish species.

The setup/import chunk in `reports/penguins.qmd` should use:

```r
here::i_am("reports/penguins.qmd")

penguins <- read.csv(
  here::here("data", "penguins.csv")
)
```

The later cleaning chunk should use:

```r
source(here::here("R", "functions.R"))
penguins_clean <- clean_penguins(penguins)
```

Run the setup chunk before later chunks during interactive work. These paths refer to the project root instead of depending on whether execution starts in the course folder or its `reports/` subfolder. See the [here documentation](https://here.r-lib.org/reference/i_am.html).

### Track the report's inputs

Because this report reads and cleans the CSV directly, its report target should explicitly track the CSV and function file:

```r
tarchetypes::tar_quarto(
  report,
  path = "reports/penguins.qmd",
  extra_files = c(
    "data/penguins.csv",
    "R/functions.R"
  )
)
```

Keep this definition inside the pipeline's `list(...)` in `_targets.R`. `extra_files` registers these inputs so their changes can invalidate the report target. See the [tar_quarto reference](https://docs.ropensci.org/tarchetypes/reference/tar_quarto.html).

The report repeats the cleaning calculation for teaching purposes, while `clean_data` provides a separately reusable pipeline result. Both should use the same saved function.

## First-time environment setup

Use this section only when the project has not yet been configured with `renv` and has no lockfile to restore.

```r
install.packages(c(
  "tidyverse",
  "targets",
  "tarchetypes",
  "quarto",
  "here",
  "renv",
  "rmarkdown"
))

renv::init()
```

After any prompted session restart, test the workflow and save the package environment:

```r
targets::tar_make()
renv::snapshot()
renv::status()
```

After changing package dependencies, update the lockfile again with `renv::snapshot()`. Commit `renv.lock`, `.Rprofile`, `renv/activate.R`, and `renv/settings.json` so others can restore the environment. See the [renv setup and collaboration guide](https://rstudio.github.io/renv/articles/renv.html).

## Git and GitHub

Keep the code, small input CSV, Quarto source, README, and environment configuration in version control. Do not commit installed package libraries, session history, or the local targets cache.

Suggested root-level `.gitignore` entries are:

```gitignore
.Rproj.user/
.Rhistory
.RData
.Ruserdata
_targets/
renv/library/
renv/staging/
.quarto/
reports/.quarto/
```

Preserve any additional ignore rules created by `renv`. After connecting the project to a GitHub repository, commit and push changes using RStudio's Git pane or Git commands. Repository creation and authentication are separate setup steps.

## Troubleshooting

### A file cannot be found

Run this in the report's setup chunk:

```r
here::i_am("reports/penguins.qmd")

here::here()
file.exists(here::here("data", "penguins.csv"))
file.exists(here::here("R", "functions.R"))
```

Both file checks should be `TRUE`. Keep the CSV in `data/`, the function in `R/`, and the report in `reports/`. Do not substitute a personal absolute Windows path in shared analysis code.

### The cleaning function refers to the wrong column

Check `names(penguins)`. This project's function must use `body_mass` and `flipper_len`. Edit and save `R/functions.R`, then source it again. Defining a corrected function only in the Console does not update the saved file.

### The targets store cannot be found

For inspecting a pipeline result, run the following from the main project folder after a successful pipeline build:

```r
penguins_clean <- targets::tar_read(
  clean_data,
  store = "_targets"
)
```

This is an optional way to inspect stored results, not a requirement for the self-contained report. See the [tar_read reference](https://docs.ropensci.org/targets/reference/tar_read.html).

## Before submitting

Restart R, open the project, run `targets::tar_make()`, and inspect the newly generated report. Confirm that the figure and data-cleaning output are present, `renv::status()` reports the intended environment, and the required project files have been pushed to GitHub.

This README documents the intended workflow; it does not certify that the latest report, environment setup, or GitHub connection has been tested successfully.
