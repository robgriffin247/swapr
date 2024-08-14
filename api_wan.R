setwd("~/git_personal/swapr/")

library(data.table)
library(duckdb)
library(jsonlite)


# api_wan(): makes a call to the swapi API to get all data for a given resource 
#   (e.g. people, films, planets) and returns a data.table
api_wan <- function(resource){
  
  url <- paste0("https://swapi.dev/api/", resource)
  dt <- data.table()
  
  while(!is.null(url)){
    message("Getting ", url)
    response <- fromJSON(url)
    url <- response$`next`
    dt <- rbind(dt, response$`results`)
  }
  
  dt
}


# r2db(): loads a data.table to a DuckDB database
r2db <- function(dt, resource, schema, prefix){
  # Load to duckdb
  con <- dbConnect(duckdb(), dbdir="data/swapr.duckdb")
  on.exit(dbDisconnect(con, shutdown = TRUE), add=TRUE)
  dbExecute(con, paste0("CREATE SCHEMA IF NOT EXISTS ", toupper(schema)))
  dbWriteTable(con, paste0(toupper(prefix), "_", toupper(resource)), dt, overwrite=TRUE)
}


# return_table(): returns a table from DuckDB (created as a function to prepackage
#   the connection logic and on.exit() call; reducing input to a query)
return_table <- function(query){
  con <- dbConnect(duckdb(), dbdir="data/swapr.duckdb")
  on.exit(dbDisconnect(con, shutdown = TRUE), add=TRUE)
  data <- dbGetQuery(con, toupper(query))
  data
}


# Demo:
# - Download data from SWAPI
starships <- api_wan("starships")

# - Store data to DuckDB database
r2db(starships, "starships", "staging", "stg")
r2db(api_wan("films"), "films", "staging", "stg")

# - Return table from DuckDB database
return_table("select * from stg_films")
return_table("show tables")