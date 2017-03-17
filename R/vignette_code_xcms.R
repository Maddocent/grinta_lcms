### R code from vignette source 'xcmsPreprocess.Rnw'

###################################################
### code chunk number 1: LibraryPreload
###################################################
library(multtest)
library(xcms)
library(faahKO)


###################################################
### code chunk number 2: RawFiles
###################################################
cdfpath <- system.file("cdf", package = "faahKO")
list.files(cdfpath, recursive = TRUE)


###################################################
### code chunk number 3: PeakIdentification
###################################################
library(xcms)
cdffiles <- list.files(cdfpath, recursive = TRUE, full.names = TRUE)
xset <- xcmsSet(cdffiles)
#xset <- faahko
xset


###################################################
### code chunk number 4: PeakMatching1
###################################################
xset <- group(xset)


###################################################
### code chunk number 5: RTCorrection
###################################################
xset2 <- retcor(xset, family = "symmetric", plottype = "mdevden")


###################################################
### code chunk number 6: PeakMatching2
###################################################
xset2 <- group(xset2, bw = 10)


###################################################
### code chunk number 7: PeakFillIn
###################################################
xset3 <- fillPeaks(xset2)
xset3


###################################################
### code chunk number 8: AnalysisVisualize
###################################################
reporttab <- diffreport(xset3, "WT", "KO", "example", 10,
                        metlin = 0.15, h=480, w=640)
reporttab[1:4,]


###################################################
### code chunk number 9: URL1
###################################################
cat("\\url{", as.character(reporttab[1,"metlin"]), "}", sep = "")


###################################################
### code chunk number 10: URL2
###################################################
cat("\\url{", as.character(reporttab[3,"metlin"]), "}", sep = "")


###################################################
### code chunk number 11: PeakSelect
###################################################
gt <- groups(xset3)
colnames(gt)
groupidx1 <- which(gt[,"rtmed"] > 2600 & gt[,"rtmed"] < 2700 & gt[,"npeaks"] == 12)[1]
groupidx2 <- which(gt[,"rtmed"] > 3600 & gt[,"rtmed"] < 3700 & gt[,"npeaks"] == 12)[1]
eiccor <- getEIC(xset3, groupidx = c(groupidx1, groupidx2))
eicraw <- getEIC(xset3, groupidx = c(groupidx1, groupidx2), rt = "raw")


###################################################
### code chunk number 12: EICRaw1
###################################################
plot(eicraw, xset3, groupidx = 1)


###################################################
### code chunk number 13: EICRaw2
###################################################
plot(eicraw, xset3, groupidx = 2)


###################################################
### code chunk number 14: EICCor1
###################################################
plot(eiccor, xset3, groupidx = 1)


###################################################
### code chunk number 15: EICCor2
###################################################
plot(eiccor, xset3, groupidx = 2)


###################################################
### code chunk number 16: warnings
###################################################
cat("These are the warning")
warnings()




### R code from vignette source 'xcmsDirect.Rnw'

###################################################
### code chunk number 1: LoadLib
###################################################
library(xcms)
library(MassSpecWavelet)


###################################################
### code chunk number 2: LoadData
###################################################
library(msdata)
mzdatapath <- system.file("fticr", package = "msdata")
mzdatafiles <- list.files(mzdatapath, recursive = TRUE, full.names = TRUE)
cat("Starting xcmsDirect.Rnw")


###################################################
### code chunk number 3: ProcessData
###################################################
data.mean <- "data.mean"
xs <- xcmsSet(
  method="MSW",
  files=mzdatafiles,
  scales=c(1,4,9),
  nearbyPeak=T,
  verbose.columns = FALSE,
  winSize.noise=500,
  SNR.method="data.mean",
  snthr=10
)


###################################################
### code chunk number 4: CreateExample
###################################################

xs4 <- xcmsSet(
  method = "MSW",
  files = mzdatafiles[1],
  scales = c(1,4, 9),
  nearbyPeak = T,
  verbose.columns = FALSE,
  winSize.noise = 500,
  SNR.method = "data.mean",
  snthr = 10)

masslist <- xs4@peaks[c(1,4,7),"mz"]
xs4@peaks[,"mz"] <- xs4@peaks[,"mz"] + 0.00001*runif(1,0,0.4)*xs4@peaks[,"mz"] + 0.0001


###################################################
### code chunk number 5: xcmsDirect.Rnw:95-103
###################################################
xs4c <- calibrate(xs4,
                  calibrants=masslist,
                  method="edgeshift",
                  mzabs=0.0001,
                  mzppm=5,
                  neighbours=3,
                  plotres=TRUE
)


###################################################
### code chunk number 6: MzClust
###################################################
xsg <- group(xs, method="mzClust")
xsg


###################################################
### code chunk number 7: ShowGroups
###################################################
groups(xsg)[1:10,]
peaks(xsg)[groupidx(xsg)[[1]]]


###################################################
### code chunk number 8: FillPeaks
###################################################
groupval(xsg)[1,]
xsgf <- fillPeaks(xsg, method="MSW")
groupval(xsgf, "medret", "into")[1:10,]


###################################################
### code chunk number 9: AnalysisVisualize
###################################################
reporttab <- diffreport(xsgf, "ham4", "ham5", "example", eicmax=4,
                        h=480, w=640)
reporttab[1:4,]


