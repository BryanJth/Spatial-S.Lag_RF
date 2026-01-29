# ---------------------------------
# Load library
# ---------------------------------
library(readxl)
library(car)
library(lmtest)
library(ggplot2)

# ---------------------------------
# Load dataset
# ---------------------------------
data <- read_excel("C:\\Users\\Bryan\\Documents\\UI Stuff\\Spasial Stuff\\T4 RF Dataset.xlsx")
data_lm <- data.frame(
  Y = data$Y,
  X1 = data$X1,
  X2 = data$X2,
  X3 = data$X3,
  X4 = data$X4
)

# ---------------------------------
# Fit model OLS
# ---------------------------------
model <- lm(Y ~ X1 + X2 + X3 + X4, data = data_lm)

# ---------------------------------
# 1. Normalitas residual (Shapiro-Wilk)
# ---------------------------------
residuals <- resid(model)
shapiro.test(residuals)

# ---------------------------------
# 2. Multikolinearitas (VIF)
# ---------------------------------
vif(model)

# ---------------------------------
# 3. Heteroskedastisitas (Breusch-Pagan)
# ---------------------------------
bptest(model)

# ---------------------------------
# 4. Autokorelasi residual (Durbin-Watson)
# ---------------------------------
dwtest(model)

# ---------------------------------
# 5. Plot residual vs fitted
# ---------------------------------
ggplot(data = data.frame(fitted = fitted(model), residuals = residuals), 
       aes(x = fitted, y = residuals)) +
  geom_point() +
  geom_hline(yintercept = 0, color = "red") +
  labs(title = "Plot Residual vs Fitted", x = "Fitted Values", y = "Residuals") +
  theme_minimal()
