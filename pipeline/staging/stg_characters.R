# Staging of character data
#setwd("~/git_personal/swapr/")
#source("functions/api_wan.R")
#source("functions/r2db.R")

r2db(api_wan("people"), "stg_characters", "staging")
