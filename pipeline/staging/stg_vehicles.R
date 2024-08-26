# Staging of vehicles data
#setwd("~/git_personal/swapr/")
#source("functions/api_wan.R")
#source("functions/r2db.R")

r2db(api_wan("vehicles"), "stg_vehicles", "staging")
