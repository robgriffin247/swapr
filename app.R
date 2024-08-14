# Demo:
setwd("~/git_personal/swapr/")
source("functions/api_wan.R")
source("functions/r2db.R")
source("functions/query_duckdb.R")

# - Get data from SWAPI
people <- api_wan("people")
starships <- api_wan("starships")

# - Store data to DuckDB database
r2db(starships, "starships", "staging", "stg")
r2db(api_wan("films"), "films", "staging", "stg")
#sapply(c("films", #"people", "planets", 
#         "species", "starships", "vehicles"), function(r){
#           r2db(api_wan(r), r, "staging", "stg")
#         })

# - Return tables from DuckDB database
query_duckdb("show tables")
query_duckdb("select * from stg_films")

# - return films from episodes IV to VI
films <- query_duckdb("select * from stg_films")
films[episode_id %in% 4:6]
