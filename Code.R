library(readxl)
setwd("E:/SJTU/Research/Meta-analysis/Draft/Nature HB/Code")
dat1 = read_excel("effect_sizes_cal.xlsx",sheet = "subgroup-diff")

# Subgroup analysis using metafor packages
library(metafor)
model_subgroup <- rma(
  yi = dat1$Hedges_g, 
  vi = dat1$g_Variance, 
  data = dat1,
  mods = ~ dat1$Subgroup1,     # Subgroup variables as covariates in the model
  method = "REML"        # It is recommended to use Restricted Maximum Likelihood (REML) estimation
)
summary(model_subgroup)

#Forest plot
forest(model_subgroup, 
       header = TRUE,
       xlab = "Effect Size (Hedges' g)",
       slab = paste("Study", dat1$Paper_ID)) 

#Subgroup analysis using meta packages
library(meta)
m.gen <- metagen(TE = dat1$Hedges_g,
                 seTE = dat1$g_Standard_error,
                 studlab = dat1$ID,
                 data = dat1,
                 sm = "SMD",
                 common = FALSE,
                 random = TRUE,
                 method.tau = "REML",
                 method.random.ci = "HK",
                 subgroup = dat1$`Subgroup 3`,
                 tau.common = FALSE,
                 title = "FW reduction interventions")
summary(m.gen)

#Forest plot
forest(m.gen, 
       sortvar = TE,
       prediction = TRUE, 
       print.tau2 = FALSE,
       leftcols = c("studlab"),
       leftlabs = c("ID"))

#predictor importance analysis
library(readxl)
library(metafor)
library(ggplot2)
library(MuMIn)
library(dmetar)
dat2 = read_excel("effect_sizes_cal.xlsx",sheet = "M.R")
multimodel.inference(TE = "Hedges_g", 
                     seTE = "g_Standard_error",
                     data = dat2,
                     predictors = c("Follow_up", "Setting", "Duration", "Stage", 
                                    "Location", "Age","Gender","Food_type","Measurement"),
                     interaction = FALSE)

#meta-regression
library(metafor)
#check for multi-collinearity
#convert categorical variables to numeric codes
library(dplyr)
dat2_numeric <- dat2 %>%
  mutate(
    Location = as.numeric(factor(Location)),
    Setting = as.numeric(factor(Setting)),
    Food_type = as.numeric(factor(Food_type)),
    Gender = as.numeric(factor(Gender)),
    Measurement = as.numeric(factor(Measurement)),
    Stage = as.numeric(factor(Stage)),
    Follow_up = as.numeric(factor(Follow_up))
  )
cor_matrix <- cor(dat2_numeric[, c("Location","Setting","Duration","Age","Food_type","Gender","Measurement","Stage","Follow_up")], 
                  use = "complete.obs")  # Drop observations that have missing values
print(cor_matrix)

#visualize multi-collinearity
library(PerformanceAnalytics)
dat2_numeric[,c("Location","Setting","Duration","Age","Food_type","Gender","Measurement","Stage","Follow_up")] %>% 
  chart.Correlation()

#fitting model
# Set the reference levels for each categorical covariate
dat2$Setting <- as.factor(dat2$Setting)
dat2$Food_type <- as.factor(dat2$Food_type)
dat2$Location <- as.factor(dat2$Location)
dat2$Gender <- as.factor(dat2$Gender)
dat2$Follow_up <- as.factor(dat2$Follow_up)
dat2$Setting <- relevel(dat2$Setting, ref = "Household")
dat2$Food_type <- relevel(dat2$Food_type, ref = "all")
dat2$Location <- relevel(dat2$Location, ref = "High Income")
dat2$Gender <- relevel(dat2$Gender, ref = "mixed")
dat2$Follow_up <- relevel(dat2$Follow_up, ref = "immediate effect")

m.reg <- rma(yi = dat2$Hedges_g, 
             sei = dat2$g_Standard_error, 
             data = dat2, 
             method = "REML", 
             mods = ~ Food_type
             + Setting 
             + Location
             + Duration 
             + Gender,
             + Follow_up, 
             test = "knha")
summary(m.reg, showlevels = TRUE)




