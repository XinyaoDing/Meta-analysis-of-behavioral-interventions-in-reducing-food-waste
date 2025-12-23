This repository stores the code developed for the paper "Leveraging behavioral interventions to tackle consumer food waste: Evidence from a meta-analysis of field experiments". 
The file "Code.R" stores the code developed for subgroup meta-analysis and meta-regression. The file "Robustness check.R" stores the code developed for funnel plot, influential studies analysis, outliers identification, and risk of bias analysis.
All the software packages used are open source and freely accessible.
A small dataset to demo the code is stored under the name "demo.xlsx". The dataset will be replaced by the full dataset used in this study when it is officially published.
R language runs on multiple operating systems including Windows, macOS, and various Linux distributions. This study uses R version 4.5.0, and core R packages used are meta and metafor packages. R packages depend on system libraries external to R and are managed through platform-specific installation commands.
Instructions to install R and RStudio can be found at: 
https://cran.r-project.org/mirrors.html (R)
https://posit.co/download/rstudio-desktop/ (RStudio)
Typical installation time for both R and RStudio is within an hour.
Instructions to run on demo dataset:
Replace the following codes with your specific working directory and file/sheet name.
setwd("E:/SJTU/Research/Meta-analysis/Draft/Nature HB/Code")
dat = read_excel("effect_sizes_cal.xlsx",sheet = "subgroup-diff")
Expected outputs are tables summarizing results from subgroup meta-analysis and meta-regression analysis, as well as various plots including funnel plot, forest plot, baujat plots and risk-of-bias plot.
Expected running time for demo is typically ranging from a few seconds to a few minutes.
How to run the code on your data: formatting your data to the “demo.xlsx” template.
