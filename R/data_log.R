## generating a data-log file, programmatically

## packages
library(tidyverse)
library(readxl)
library(lubridate)


## load project root folder as object
source("./R/PROJ_ROOT.R")
## list files in folder "./data-raw"

dirs <- list.dirs(paste0(PROJ_ROOT, "/data-raw"), recursive = FALSE, 
                                           full.names = TRUE)

files <- lapply(dirs, list.files)
  
  
data_id <- list.dirs(paste0(PROJ_ROOT, "/data-raw"), recursive = FALSE, 
                     full.names = FALSE)

date_recieved <- c(date("2015-12-15"), date("2016-04-29"))
date_recieved

data_log <- cbind(data_id, dirs, date_recieved)




