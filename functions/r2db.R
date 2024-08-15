# r2db(): loads a data.table to a DuckDB database
library(data.table)
library(duckdb)

r2db <- function(dt, table, schema){
  # Remove list variables
  dt <- dt[, .SD, .SDcols=dt[, !sapply(.SD, is.list)]]
  
  # Load to duckdb
  con <- dbConnect(duckdb(), dbdir="data/swapr.duckdb")
  on.exit(dbDisconnect(con, shutdown = TRUE), add=TRUE)
  dbExecute(con, paste0("CREATE SCHEMA IF NOT EXISTS ", toupper(schema)))
  dbWriteTable(con, toupper(table), dt, overwrite=TRUE)
}