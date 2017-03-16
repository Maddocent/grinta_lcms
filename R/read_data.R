library(readxl)
library(tidyverse)
LCMS_data <- 
  read_excel("~/grinta_lcms/data/LCMS data fietser 2 en 3.xlsx",
             skip = 1)
View(LCMS_data)
names(LCMS_data)

lcms_gather <- LCMS_data %>% gather()

?gather


plot(LCMS_data)
