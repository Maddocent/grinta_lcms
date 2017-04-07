## PROJ_ROOT

if(!require("rprojroot")) install.packages("rprojroot", dependencies = TRUE)
library(rprojroot)
PROJ_ROOT <- rprojroot::find_root_file(criterion = is_rstudio_project)
