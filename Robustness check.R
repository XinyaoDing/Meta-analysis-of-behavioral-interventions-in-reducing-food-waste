library(readxl)
#set working directory
setwd("E:/SJTU/Research/Meta-analysis/Code")
dat1 = read_excel("demo.xlsx",sheet = "effect sizes")

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

#Influential studies
library(ggplot2)
library(gridExtra)
library(meta)
library(metafor)
library(dmetar)
m.gen.inf <- InfluenceAnalysis(m.gen, random = TRUE)
plot(m.gen.inf, "baujat")
plot(m.gen.inf, "influence")
plot(m.gen.inf, "es")
plot(m.gen.inf, "i2")
print(m.gen.inf)

#find outliers
find.outliers(m.gen)
spot.outliers.random(m.gen)

# Produce funnel plot
meta::funnel(m.gen,
             xlim = c(-3, 1),
             ylim = c(0.75,0),
             studlab = TRUE)
title("Funnel Plot (FW reduction interventions)")

# Generate contour-enhanced funnel plots
# Define fill colors for contour
col.contour = c("gray75", "gray85", "gray95")
# Generate funnel plot (we do not include study labels here)
meta::funnel(m.gen, xlim = c(-3, 1),
             ylim = c(0.75,0),
             contour = c(0.9, 0.95, 0.99),
             col.contour = col.contour)
# Add a legend
legend(x = -2.5, y = 0.01, 
       legend = c("p < 0.1", "p < 0.05", "p < 0.01"),
       fill = col.contour)
# Add a title
title("Contour-Enhanced Funnel Plot (FW reduction interventions)")

#Risk-of-bias plot for RCTs (RoB2.0)
library(robvis)
my_rob_data = read_excel("demo.xlsx",sheet = "RoB2.0")
rob_summary(data = my_rob_data, 
            tool = "ROB2",
            overall = TRUE)
png("risk_of_bias_plot.png", width = 10, height = 3.4, units = "in", res = 1000)
rob_summary(data = my_rob_data, tool = "ROB2", overall = TRUE)
dev.off()

#Risk-of-bias plot for quasi-experiments (ROBINS-I)
library(robvis)
my_rob_data = read_excel("demo.xlsx",sheet = "ROBINS-I")
rob_summary(data = my_rob_data, 
            tool = "ROBINS-I",
            overall = TRUE)
png("risk_of_bias_plot.png", width = 10, height = 3.4, units = "in", res = 1000)
rob_summary(data = my_rob_data, tool = "ROBINS-I", overall = TRUE)
dev.off()
