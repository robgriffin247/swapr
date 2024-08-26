# Staging of starships data
#setwd("~/git_personal/swapr/")
#source("functions/api_wan.R")
#source("functions/r2db.R")

r2db(api_wan("starships"), "stg_starships", "staging")
