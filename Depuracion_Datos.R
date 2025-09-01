install.packages("writexl")

library(dplyr)
library(readxl)
library(writexl)

# 1. Cargar datos
spotify <- read_excel("Spotify2024.xlsx")

# 2. Limpiar nombres de columnas
names(spotify) <- make.names(names(spotify))

# 3. Eliminar columnas vacías (las ...30, ...31, etc.)
spotify <- spotify %>%
  select(-starts_with("..."))

# 4. Convertir columnas numéricas (quitar comas y pasar a numeric)
cols_numericas <- c("spotify_streams", "spotify_alcance", "youtube_views", 
                    "youtube_likes", "tiktok_posts", "tiktok_likes", 
                    "tiktok_views", "youtube_alcance", "deezer_alcance", 
                    "pandora_streams", "soundcloud_streams", "shazam")

spotify <- spotify %>%
  mutate(across(all_of(cols_numericas),
                ~as.numeric(gsub(",", "", .))))

# 5. Convertir fecha
spotify <- spotify %>%
  mutate(fecha_lanz = suppressWarnings(as.Date(as.numeric(fecha_lanz), 
                                               origin = "1899-12-30")))

# 6. Rellenar NAs en algunas columnas
spotify <- spotify %>%
  mutate(
    deezer_playlists = ifelse(is.na(deezer_playlists), 0, deezer_playlists),
    shazam           = ifelse(is.na(shazam), 0, shazam)
  )

# 7. Eliminar duplicados
spotify <- spotify %>% distinct()

# 8. Guardar limpio
write.csv(spotify, "Spotify2024_clean.csv", row.names = FALSE)

# ---- confirmación de la depuración ----

# Cargar la librería tidyverse
library(tidyverse)

# ---- PASO 1: CARGAR EL ARCHIVO CSV LIMPIO ----
# El archivo ya está bien formateado, lo leemos directamente
spotify_data <- read_csv("Spotify2024_clean.csv")

# ---- PASO 2: CONVERTIR TIPOS DE DATOS ----
spotify_limpio <- spotify_data %>%
  # Convierte la columna de fecha a formato 'Date'
  mutate(fecha_lanz = ymd(fecha_lanz)) %>%
  
  # Convierte la columna 'explicito' (0 o 1) a un tipo lógico
  mutate(explicito = as.logical(explicito))

# ---- PASO 3: INSPECCIONAR LOS DATOS ----
# Muestra la estructura de los datos para confirmar que los tipos son correctos
glimpse(spotify_limpio)
