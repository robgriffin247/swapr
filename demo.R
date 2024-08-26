# Demo:
setwd("~/git_personal/swapr/")
source("functions/api_wan.R")
source("functions/r2db.R")
source("functions/count_ducku.R")

# - Get data from SWAPI
people <- api_wan("people")
starships <- api_wan("starships")

# - Store data to DuckDB database
r2db(starships, "stg_starships", "staging")
r2db(api_wan("films"), "stg_films", "staging")
sapply(c("films", "people", "planets", "species", "starships", "vehicles"), function(r){
           r2db(api_wan(r), paste0("stg_", r), "staging")
         })

# - Return tables from DuckDB database
count_ducku("show tables")
count_ducku("select * from stg_films")

# - Return films from episodes IV to VI
films <- count_ducku("select * from stg_films")
films[episode_id %in% 4:6]

# - Create a list containing all data.tables
all_data <- list()
for (dt in count_ducku("show tables")[, name]){
  all_data[[dt]] <- count_ducku(paste0("select * from ", dt))
}

