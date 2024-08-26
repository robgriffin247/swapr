# Staging of films data
setwd("~/git_personal/swapr/")
source("functions/api_wan.R")
source("functions/r2db.R")

r2db(api_wan("films"), "stg_films", "staging")
