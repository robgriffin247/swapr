library(httr2)
library(data.table)

api_wan <- function(resource){
  
  url <- paste0("https://swapi.dev/api/", resource)
  dt <- data.table()
  
  while(!is.null(url)){
    message("Getting ", url)
    resp <- req_perform(request(url))
    resp_json <- resp_body_json(resp)
    dt <- rbind(dt, rbindlist(lapply(lapply(resp_json$results, t), data.table)))
    url <- resp_json$`next`
  }
  
  dt
    
}

api_wan("people")
