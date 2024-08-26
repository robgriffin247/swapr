setwd("~/git_personal/swapr/")
source("functions/r2db.R")
source("functions/count_ducku.R")

r2db(
  count_ducku("select * from stg_films")[
    , .("id"=url, 
        "film"=title, 
        "episode"=episode_id, 
        director, 
        "producers"=producer, 
        "release_date"=as.Date(release_date))],
  "int_films",
  "intermediate"
)
