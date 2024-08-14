# api_wan(): makes a call to the swapi API to get all data for a given resource 
#   (e.g. people, films, planets) and returns a data.table
library(data.table)
library(jsonlite)

api_wan <- function(resource){
  
  if(!(tolower(resource) %in% c("films", "people", "planets", "species", "starships", "vehicles"))){
    stop("Resource must be one of films, people, planets, species, starships and vehicles.")
  }
  
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