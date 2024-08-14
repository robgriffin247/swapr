# r2db(): loads a data.table to a DuckDB database
library(data.table)
library(duckdb)

r2db <- function(dt, resource, schema, prefix){
  # Load to duckdb
  con <- dbConnect(duckdb(), dbdir="data/swapr.duckdb")
  on.exit(dbDisconnect(con, shutdown = TRUE), add=TRUE)
  dbExecute(con, paste0("CREATE SCHEMA IF NOT EXISTS ", toupper(schema)))
  dbWriteTable(con, paste0(toupper(prefix), "_", toupper(resource)), dt, overwrite=TRUE)
}