
if (!requireNamespace("devtools", quietly = TRUE)) {
  install.packages("devtools")
}
if (!requireNamespace("sf", quietly = TRUE)) {
  install.packages("sf")
}
if (!requireNamespace("readxl", quietly = TRUE)) {
  install.packages("readxl")
}
if (!requireNamespace("spatialRF", quietly = TRUE)) {
  devtools::install_github("BlasBenito/spatialRF")
}

library(sf)
library(readxl)
library(spatialRF)

data <- read_excel("C:\\Users\\Bryan\\Documents\\UI Stuff\\Spasial Stuff\\T4 RF Dataset.xlsx")

data_rf <- data.frame(
  Y = data$Y,
  X1 = data$X1,
  X2 = data$X2,
  X3 = data$X3,
  X4 = data$X4,
  latitude = data$latitude,
  longitude = data$longitude
)

coords <- data_rf[, c("longitude", "latitude")]
dist_matrix <- as.matrix(dist(coords))

rf_model <- rf_spatial(
  data = data_rf,
  dependent.variable.name = "Y",
  predictor.variable.names = c("X1", "X2", "X3", "X4"),
  distance.matrix = dist_matrix,
  n.cores = 2
)


print(rf_model)
plot_importance(rf_model)


# Ambil residual
data_rf$residual <- rf_model$residuals$values

# Load shapefile untuk plot spasial
shp <- st_read("C:\\Users\\Bryan\\Documents\\UI Stuff\\Spasial Stuff\\[geosai.my.id]Jawa_Timur_Kab\\Jawa_Timur_ADMIN_BPS.shp") # pastikan path-nya sama

shp$residual <- data_rf$residual

# Plot peta residual
library(ggplot2)
ggplot(shp) +
  geom_sf(aes(fill = residual), color = "white") +
  scale_fill_gradient2(
    low = "white", mid = "pink", high = "red",
    midpoint = 0, name = "Residual"
  ) +
  labs(
    title = "Random Forest Residual Map",
    caption = "Data: Kabupaten/Kota di Jawa Timur"
  ) +
  theme_minimal()