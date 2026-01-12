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
