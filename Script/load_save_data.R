############################
# Laddar och sparar data####
############################

############### Laddar paket och ställer in settings
{
  source("Script/install_load_packages.R")
  source("Script/settings.R")
  source("Script/search_kolada.R")
  
  install_and_load()
  settings <- get_settings()
  
  kommunkod <- settings$kommunkod
  kommuner <- settings$kommuner
  kommun_colors <- settings$kommun_colors
  riket_narliggande <- settings$riket_narliggande
  lanskod <- settings$lanskod
  lan <- settings$lan
  
}


# Skapar folder för data om den inte existerar
if (!file.exists('Data')){
  dir.create('Data')
}

##### Deso
{
# 2025

url <- "https://geodata.scb.se/geoserver/stat/wfs?service=WFS&REQUEST=GetFeature&version=1.1.0&TYPENAMES=stat:DeSO_2025&outputFormat=geopackage"
output_file <- "Data/DeSO_2025.gpkg"

# Kollar om den redan finns
if (file.exists(output_file)) {
  
} else {
  
  response <- GET(url, write_disk(output_file, overwrite = TRUE))
  
}

# 2018

url <- "https://geodata.scb.se/geoserver/stat/wfs?service=WFS&REQUEST=GetFeature&version=1.1.0&TYPENAMES=stat:DeSO_2018&outputFormat=geopackage"
output_file <- "Data/DeSO_2018.gpkg"

# Kollar om den redan finns
if (file.exists(output_file)) {
  
} else {
  
  response <- GET(url, write_disk(output_file, overwrite = TRUE))
  
}

# Kopplingar 
# 2025
url <- 'https://www.scb.se/contentassets/e3b2f06da62046ba93ff58af1b845c7e/koppling-deso2025-regso2025.xlsx'
output_file <- "Data/koppling-deso2025-regso2025.xlsx"

# Kollar om den redan finns
if (file.exists(output_file)) {
  
} else {
  
  response <- GET(url, write_disk(output_file, overwrite = TRUE))
  
}
# 2018
url <- 'https://www.scb.se/contentassets/e3b2f06da62046ba93ff58af1b845c7e/koppling-deso2018-regso2020.xlsx'
output_file <- "Data/koppling-deso2018-regso2020.xlsx"

# Kollar om den redan finns
if (file.exists(output_file)) {
  
} else {
  
  response <- GET(url, write_disk(output_file, overwrite = TRUE))
  
}

print('Nedladdning av "DeSO" har genomförts')


############# Shape-fil    #########
url <- 'https://www.scb.se/contentassets/3443fea3fa6640f7a57ea15d9a372d33/shape_svenska_250121.zip'
output_file <- "Data/shape.zip"

# Kollar om den redan finns
if (file.exists(output_file)) {
  
} else {
  
  response <- GET(url, write_disk(output_file, overwrite = TRUE))
  
}

# Extrahera ZIP-filen
unzip("Data/shape.zip", files = "Kommun_Sweref99TM.zip", exdir = "Data")
unzip("Data/shape.zip", files = "LanSweref99TM.zip", exdir = "Data")
unzip("Data/Kommun_Sweref99TM.zip", exdir = "Data/Kommun_Sweref99TM")
unzip("Data/LanSweref99TM.zip", exdir = "Data/Lan_Sweref99TM")

print('Nedladdning av "Kommun_Sweref99TM" har genomförts')
}



########### Deso land/vatten areal ##############
# https://www.statistikdatabasen.scb.se/pxweb/sv/ssd/START__MI__MI0802/Areal2025/
url <- 'https://api.scb.se/OV0104/v1/doris/sv/ssd/START/MI/MI0802/Areal2025'

meta <- pxweb_get(url)

# Visa tillgängliga regionkoder
regioner <- meta$variables[[1]]$values

# Välj endast regioner som börjar med "03"
uppsala_koder <- regioner[startsWith(regioner, lanskod)]

pxweb_query_list <- list(
  "Region" =uppsala_koder , # Uppsala läns kommuner
  "ArealTyp" = '*', 
  'ContentsCode' = '*',
  "Tid" = c("*")    # Årtal att hämta data för
)

px_data <- pxweb_get(url,pxweb_query_list)
px_deso <- as.data.frame(px_data, column.name.type = "text", variable.value.type = "text")

write.csv(px_deso, "Data/df_deso_land_vatten.csv", row.names = F)

print('Nedladdning av "df_deso_land_vatten.csv" har genomförts')



############# Kolada 

############## Bredband tillgång ##################
# Tillgång till fast berdband om minst 100 Mbit/s, Andel%
{
  df_internet <- search_and_fetch_kolada("Tillgång till fast bredband ")
  df_internet <- df_internet %>% filter(year >= 2010)
  write.csv(df_internet, "Data/df_internet.csv", row.names = F)
  print('Nedladdning av "df_internet.csv" har genomförts')
}

# Hushåll med tillgång till eller möjlighet att ansluta till bredband om minst 1 Gbit/s, andel (%)
{
  df_internet_gb <- search_and_fetch_kolada("Hushåll med tillgång till eller möjlighet att ansluta till bredband om minst 1 Gbit/s")
  unique(df_internet_gb$title)
  write.csv(df_internet_gb, "Data/df_internet_gb.csv", row.names = F)
  print('Nedladdning av "df_internet_gb.csv" har genomförts')
}


# Internetstiftelsens och Bredbandskollens mätningar
{
  df_bredbandskollen <- search_and_fetch_kolada("Bredbandskollen, genomsnittligt")
  unique(df_bredbandskollen$title)
  write.csv(df_bredbandskollen, "Data/df_bredbandskollen.csv", row.names = F)
  print('Nedladdning av "df_bredbandskollen.csv" har genomförts')
}


############## ###########
# PTS Mobiltäcknings- och bredbandskartläggning.
# https://statistik.pts.se/telekom-och-bredband/mobiltackning-och-bredband/dokument/

# Direktlänkar till Excel-filerna för mobiltäckning
url_mobiltackning <- "https://statistik.pts.se/media/aecfgy4i/tabelbilaga-mobiltäckning-1-3.xlsx"

# Sökvägar där filerna ska sparas
dest_mobiltackning <- file.path("Data", "mobiltackning.xlsx")

# Ladda ned filerna
download.file(url_mobiltackning, dest_mobiltackning, mode = "wb")

# Teknik 
url_teknik <- 'https://statistik.pts.se/media/b2rhdc1g/tabellbilaga-teknik-1-1.xlsx'

# Sökvägar där filerna ska sparas
teknik <- file.path("Data", "teknik.xlsx")

# Ladda ned filerna
download.file(url_teknik, teknik, mode = "wb")
