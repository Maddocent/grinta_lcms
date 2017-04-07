
Rprof(
## ----setup, include=FALSE------------------------------------------------
knitr::opts_chunk$set(echo = TRUE, warning = FALSE, message = FALSE, error = FALSE)

## ------------------------------------------------------------------------
library("mzR") 
library(tidyverse)
library(rprojroot)
library(xcms)
library(pander)

## ---- eval = FALSE-------------------------------------------------------
## browseVignettes(package = "xcms")

## ----define_project_root, include=FALSE----------------------------------
if(!require("rprojroot")) install.packages("rprojroot", dependencies = TRUE)
root <- rprojroot::find_root_file(criterion = is_rstudio_project)
root

## ------------------------------------------------------------------------
filepath <- paste0(root, "/data-raw/grouped")
(list.files(filepath, full.names = TRUE, recursive = TRUE))

## ------------------------------------------------------------------------
create_xset_from_mzfiles <- function(filepath, pattern) {
 files_x <- list.files(filepath, full.names = TRUE, 
                       pattern = pattern, 
                       recursive = TRUE)
 xset <- xcmsSet(files = files_x, verbose = TRUE)
 
 return(xset)
}

## ------------------------------------------------------------------------
test_xset <- create_xset_from_mzfiles(filepath = filepath, pattern = "*.mzXML")
test_xset

## ---- eval=FALSE---------------------------------------------------------
## ## save resulting xcmsSet to file
## save(test_xset, file = "xcmsSet_grinta_test.Rda")
## 
## ## load saved xcmsSet to Global Env.
## load(file = paste0(root, "/xcmsSet_grinta_test.Rda"))
## test_xset

## ------------------------------------------------------------------------
xset <- group(test_xset)
# accessors to the xcms object
head(xset@groups)
head(xset@peaks)

## ------------------------------------------------------------------------
(retcor(xset, family = "symmetric", plottype = "mdevden"))

## ------------------------------------------------------------------------
xset2 <- group(xset, bw = 20)
xset2
head(xset2@groups)

## ------------------------------------------------------------------------
xset3 <- fillPeaks(xset2)
xset3

## ------------------------------------------------------------------------
(retcor(xset3, family = "symmetric", plottype = "mdevden"))

## ---- echo=FALSE---------------------------------------------------------
reporttab_t0vst60 <- diffreport(xset3, "t1_0", "t2_60", filebase = "t0_vs_t60", 
                        eicmax = 20, eicwidth = 1,
                        metlin = 0.15, h=480, w=640, sortpval = TRUE)

reporttab_t60vst180 <- diffreport(xset3, "t2_60", "t3_180", filebase = "t60_vs_t180", 
                        eicmax = 20, eicwidth = 1,
                        metlin = 0.15, h=480, w=640, sortpval = TRUE)

reporttab_t0vst180 <- diffreport(xset3, "t1_0", "t3_180", filebase = "t0_vs_t180", 
                        eicmax = 20, eicwidth = 1,
                        metlin = 0.15, h=480, w=640, sortpval = TRUE)

reporttab_t0vst60$comparison <- c("t0_vs_t60")
reporttab_t60vst180$comparison <- c("t60_vs_t180")
reporttab_t0vst180$comparison <- c("t0_vs_t180")

reporttab <- rbind(reporttab_t0vst60, reporttab_t60vst180, reporttab_t0vst180) %>%
  as_tibble() %>% arrange(pvalue) %>% 
  select(name, fold, pvalue, mzmed, rtmed, comparison, metlin)

head(as_tibble(reporttab), 15)

## ------------------------------------------------------------------------
knitr::include_graphics(paste0(root, "/rmarkdown/t0_vs_t60_box/001.png"))

## ------------------------------------------------------------------------
head(significant <- reporttab %>% filter(pvalue <= 0.05) %>%
  mutate(rt_minutes = rtmed/60) %>% select(name, fold, 
                                        pvalue, 
                                        rt_minutes, comparison, metlin) %>%
arrange(pvalue) %>% as_tibble(), 10)

## ------------------------------------------------------------------------
###################################################
(as.character(reporttab[1,"metlin"]))
(as.character(reporttab[2,"metlin"]))


## ------------------------------------------------------------------------
(as.character(significant$name))[1:10]

## ---- eval=FALSE---------------------------------------------------------
## gt <- groups(xset3)
## colnames(gt)
## min_rt_from_reporttab <- min(reporttab$rtmed)
## max_rt_from_reporttab <- max(reporttab$rtmed)
## min_mz_from_reporttab <- min(reporttab$mzmed)
## max_mz_from_reporttab <- max(reporttab$mzmed)
## 
## find_groupidx <- function(x_set, min_rt, max_rt, min_mz, max_mz, n_peaks, group_id){
## 
##   gt <- groups(x_set)
##   groupidx <-
##   which(gt[,"rtmed"] > min_rt & gt[,"rtmed"] <  max_rt & gt[,"npeaks"] == n_peaks)[group_id]
## 
##  return(groupidx)
## }
## 
## rtmin = min_rt_from_reporttab
## mzmax = max_mz_from_reporttab
## rtmax = max_rt_from_reporttab
## mzmin = min_mz_from_reporttab
## 
## mzrange = as.matrix(cbind(mzmin, mzmax))
## rtrange = as.matrix(cbind(rtmin, rtmax))
## 
## groupidx1 <- find_groupidx(x_set = xset3,
##                            min_rt = min_rt_from_reporttab,
##                            max_rt = max_rt_from_reporttab,
##                            min_mz = min_mz_from_reporttab,
##                            max_mz = max_mz_from_reporttab,
##                            n_peaks = 7,
##                            group_id = 1)
## 
## groupidx2 <- find_groupidx(x_set = xset3,
##                            min_rt = min_rt_from_reporttab,
##                            max_rt = max_rt_from_reporttab,
##                            min_mz = min_mz_from_reporttab,
##                            max_mz = max_mz_from_reporttab,
##                            n_peaks = 9,
##                            group_id = 2)
## 
## eiccor <- getEIC(xset3, groupidx = c(groupidx1, groupidx2), rt = )
## eicraw <- getEIC(xset3, groupidx = c(groupidx1, groupidx2), rt = "raw")
## 
## eiccor2 <- getEIC(xset3, mzrange = mzrange, rtrange = rtrange, groupidx = c(groupidx1, groupidx2), rt = "corrected" )
## 
## png(filename = "eiccor_1.png")
## plot(eiccor2, xset3, groupidx = 1)
## dev.off()
## 
## png(filename = "eicraw_2.png")
## plot(eicraw, xset3, groupidx = 2)
## dev.off()
## 
)
