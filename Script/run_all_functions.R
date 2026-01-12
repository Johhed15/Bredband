####### Kör alla andra scripts 
####### Laddar ner data
####### Sparar plots 

{
  source("Script/install_load_packages.R")
  source("Script/settings.R")
  install_and_load()
  settings <- get_settings()
  
  kommunkod <- settings$kommunkod
  kommuner <- settings$kommuner
  kommun_colors <- settings$kommun_colors
  upplat_colors <- settings$upplat_colors
  source("Script/load_save_data.R")
  source("Script/create_save_plots.R")
  source("Script/create_tasbles.R")
}






######### Funktioner som sparar bilder till folder: "Figurer", Många är interaktiva i denna rapport och sparas inte

# Bredbandskollen

bredbandskollen()

# Fem G
femg()

# Teknik
teknik()

## Tabell till mobildata
mobilt_agg_tbl()

mobilt_tbl()