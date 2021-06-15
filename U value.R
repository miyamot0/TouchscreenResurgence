Data <- read.csv ("Swipe U Value.csv", header = TRUE)

library(nlme)

#--

result <- groupedData(Uvalue ~ as.factor(Group) * as.factor(Phase) * as.numeric(Time) | id, data = Data)

fit <- gls(Uvalue ~ Group * Phase * Time, data = result,
              corr = corCompSymm(, form= ~ 1 | id))
summary(fit)

#--

#Removing 3-way interaction
fitb <- gls(Uvalue ~ Group + Phase + Time + Group:Phase + Group:Time + Phase:Time, data = result,
              corr = corCompSymm(, form= ~ 1 | id))

summary(fitb)

anova(fit,fitb)
#not sig, going with simpler model (fitb)

#--

#Removing Group:Time
fitc <- gls(Uvalue ~ Group + Phase + Time + Group:Phase + Phase:Time, data = result,
            corr = corCompSymm(, form= ~ 1 | id))

summary(fitc)

anova(fitb,fitc)
#sig., going with fitc

#--

#Removing Group:Phase
fitd <- gls(Uvalue ~ Group + Phase + Time + Phase:Time, data = result,
            corr = corCompSymm(, form= ~ 1 | id))

summary(fitd)

anova(fitc,fitd)
#not sig., going with simpler model (fitd)

#--

#Removing Phase:Time
fite <- gls(Uvalue ~ Group + Phase + Time, data = result,
            corr = corCompSymm(, form= ~ 1 | id))

summary(fite)

anova(fitd,fite)
#not sig., going with simpler model (fite)

#--

#Removing Group
fitf <- gls(Uvalue ~ Phase + Time, data = result,
            corr = corCompSymm(, form= ~ 1 | id))

summary(fitf)

anova(fite,fitf)
#not sig., going with simpler model (fitf)

#--
summary(fitf)

# Generalized least squares fit by REML
# Model: Uvalue ~ Phase + Time 
# Data: result 
# AIC       BIC   logLik
# -53.17313 -38.22096 31.58656
# 
# Correlation Structure: Compound symmetry
# Formula: ~1 | id 
# Parameter estimate(s):
#   Rho 
# 0.1889132 
# 
# Coefficients:
#   Value  Std.Error    t-value p-value
# (Intercept) -1.3674275 0.10778884 -12.686170       0
# Phase        0.7559149 0.04160740  18.167800       0
# Time        -0.0995957 0.01998755  -4.982887       0
# 
# Correlation: 
#   (Intr) Phase 
# Phase -0.980       
# Time   0.742 -0.721
# 
# Standardized residuals:
#   Min          Q1         Med          Q3         Max 
# -1.80477893 -0.75130757 -0.09643204  0.46044394  3.16239685 
# 
# Residual standard error: 0.1922014 
# Degrees of freedom: 150 total; 147 residual

emmeans::emmeans(fitf, pairwise~Phase, adjust="Bonferroni",at = list(Time = c(0)))
# $emmeans
# Phase emmean     SE   df lower.CL upper.CL
# 2  0.144 0.0311 14.1   0.0778    0.211
# 3  0.900 0.0288 15.3   0.8390    0.962
# 
# Degrees-of-freedom method: satterthwaite 
# Confidence level used: 0.95 
# 
# $contrasts
# contrast estimate     SE   df t.ratio p.value
# 2 - 3      -0.756 0.0416 8.99 -18.168 <.0001 
# 
# Degrees-of-freedom method: satterthwaite 





