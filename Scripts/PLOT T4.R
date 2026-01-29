# Boxplot
library(ggplot2)
library(readxl)

data <- read_excel("C:\\Users\\Bryan\\Documents\\UI Stuff\\Spasial Stuff\\T4 RF Dataset.xlsx")
data_rf <- data.frame(
  Y = data$Y,
  X1 = data$X1,
  X2 = data$X2,
  X3 = data$X3,
  X4 = data$X4
)

# Boxplot semua variabel
library(reshape2)
data_melt <- melt(data_rf)
ggplot(data_melt, aes(x=variable, y=value, fill=variable)) +
  geom_boxplot() +
  labs(title="Boxplot Variabel Kemiskinan & Prediktor", y="Nilai", x="Variabel") +
  theme_minimal()

# Peta Sebaran (pakai sf)
library(sf)
shp <- st_read("C:\\Users\\Bryan\\Documents\\UI Stuff\\Spasial Stuff\\[geosai.my.id]Jawa_Timur_Kab\\Jawa_Timur_ADMIN_BPS.shp")
shp$Kemiskinan <- data$Y  # Gabungkan Y

# Plot peta sebaran kemiskinan
ggplot(shp) +
  geom_sf(aes(fill=Kemiskinan), color="white") +
  scale_fill_viridis_c() +
  labs(title="Peta Sebaran Persentase Kemiskinan di Jawa Timur", fill="% Kemiskinan") +
  theme_minimal()