setwd("~/git_personal/swapr/")
dir.create("pipeline/intermediate", recursive=TRUE)
sapply(c("films", "characters", "planets", "vehicles", "starships", "species"),
       function(resource){
         f <- paste0("pipeline/intermediate/int_", resource, ".R")
         file.create(f)
         cat('
source("functions/api_wan.R")\n
source("functions/r2db.R")\n
source("functions/count_ducku.R")\n

'
             , file=f)
       })
