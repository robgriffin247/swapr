# SWAPR

SWAPR (*swapper*) is a project to demonstrate the use of R for data engineering. It will, among other things:

- [x] Extract data from the Star Wars API (**SWAPI**)
- [x] Load SWAPI data into a DuckDB database
- [ ] Transform raw data into production ready datasets
- [ ] Utilise production ready datasets in a Shiny web app or similar end-product

### Using R

R is statstical programming language, popular among academics, analysts, statisticians and data scientists &mdash; many of the end users of data prepared by data engineers. R is an interpretted language and most developers are using RStudio as their development environment as it includes a console/CLI to interact with the R interpreter and a number of other integrated features &mdash; [download and install RStudio](https://posit.co/download/rstudio-desktop/) or [create an account and use RStudio Cloud](https://login.posit.cloud/) in your browser.



### Extract data from SWAPI

1. Create a new R script.

1. Load the `jsonlite` and `data.table` packages using the `library()` function (and install them first by executing e.g. `install.packages("data.table")` in the console if you haven't done this before).

    ```r
    library(data.table)
    library(jsonlite)
    ```

1. Create a function to get data from `https://swapi.dev/api` then call the function to see which resources exist.

    ```r
    library(data.table)
    library(jsonlite)

    api_wan <- function(){
        url <- "https://swapi.dev/api/"
        fromJSON(url)
    }

    api_wan()
    ```

1. Modify the function to allow the call to request a specific resource. This will return four variables on the requested resource &mdash; a `count` of the number of resources, `next` and `previous` showing the url for the next and previous pages of data (SWAPI has 10 per page), and `results` which is the focal data.
    ```r
    library(data.table)
    library(jsonlite)

    api_wan <- function(resource){
        url <- paste0("https://swapi.dev/api/", resource)
        fromJSON(url)
    }

    api_wan("films")
    ```

    ```r
    > api_wan("films")
    $count
    [1] 6

    $`next`
    NULL

    $previous
    NULL

    $results
                        title episode_id   ...
    1              A New Hope          4   ...
    2 The Empire Strikes Back          5 
    3      Return of the Jedi          6
    4      The Phantom Menace          1
    5    Attack of the Clones          ...
    6                     ...          ...
    ...
    
    ```

1. Modify with a `while` loop to work through the pages of data and join them into a single data.table. The `!is.null(url)` will cause the `while` loop to continue until the value of `url`, which updates each iteration, is `NULL`. Note that `dt` is created to allow joining through the loop &mdash; in the first iteration, the data is joined to an empty data.table.

    ```r
    library(data.table)
    library(jsonlite)

    api_wan <- function(resource){
    
        url <- paste0("https://swapi.dev/api/", resource)
        dt <- data.table()
    
        while(!is.null(url)){
            response <- fromJSON(url)
            url <- response$`next`
            dt <- rbind(dt, response$`results`)
        }
    
        dt
    }

    api_wan("people")    
    ```



### Load data to DuckDB

1. Create a new R script.

1. Load the `duckdb` and `data.table` packages.

    ```r
    library(duckdb)
    library(data.table)
    ```

1.  Create a connection to a database called `swapr.duckdb`. Add an `on.exit()` call to make the connection close even if an error occurs during the execution of the function.

    ```r
    r2db <- function(){
        con <- dbConnect(duckdb(), dbdir="data/swapr.duckdb")
        on.exit(dbDisconnect(con, shutdown = TRUE), add=TRUE)
    }
    ```

1. Create a schema for the data using `dbExecute()`, including `IF NOT EXISTS`.

    ```r
    r2db <- function(schema){
        con <- dbConnect(duckdb(), dbdir="data/swapr.duckdb")
        on.exit(dbDisconnect(con, shutdown = TRUE), add=TRUE)
        dbExecute(con, paste0("CREATE SCHEMA IF NOT EXISTS ", toupper(schema)))
    }
    ```

1. Load the data, `dt`, into the database, here adding a `table` name to suit the data.

    ```r
    r2db <- function(dt, table, schema){
        con <- dbConnect(duckdb(), dbdir="data/swapr.duckdb")
        on.exit(dbDisconnect(con, shutdown = TRUE), add=TRUE)
        dbExecute(con, paste0("CREATE SCHEMA IF NOT EXISTS ", toupper(schema)))
        dbWriteTable(con, toupper(table), dt, overwrite=TRUE)
    }
    ```

1. Some datasets will contain columns of list data (e.g. vehicles in people). These columns need to be removed as DuckDB doesn't know how to handle this R type.

    ```r
    r2db <- function(dt, table, schema){
        dt <- dt[, .SD, .SDcols=dt[, !sapply(.SD, is.list)]]

        con <- dbConnect(duckdb(), dbdir="data/swapr.duckdb")
        on.exit(dbDisconnect(con, shutdown = TRUE), add=TRUE)
        dbExecute(con, paste0("CREATE SCHEMA IF NOT EXISTS ", toupper(schema)))
        dbWriteTable(con, toupper(table), dt, overwrite=TRUE)
    }
    ```

1. Load data to the database.

    ```r
    r2db(api_wan("people"), "stg_people", "staging")
    ```