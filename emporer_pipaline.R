setwd("~/git_personal/swapr/")
library(parallel)

source("functions/api_wan.R")
source("functions/r2db.R")
source("functions/count_ducku.R")

mclapply(paste0("pipeline/staging/", list.files("pipeline/staging/")), source)
