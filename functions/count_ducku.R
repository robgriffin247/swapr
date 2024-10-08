# count_ducku(): returns a data.table from DuckDB (created as a function to 
#   pre-pack the connection logic and on.exit() call; reducing input to a query)
library(data.table)
library(duckdb)

count_ducku <- function(query){
  con <- dbConnect(duckdb(), dbdir="data/swapr.duckdb")
  on.exit(dbDisconnect(con, shutdown = TRUE), add=TRUE)
  data.table(dbGetQuery(con, toupper(query)))
}