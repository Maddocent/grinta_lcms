library (rJava)
.jinit ()
library(mzmatch.R)
mzmatch.init()

### Do not alter the script above this line
### it loads the required libraries


## Organising positive experimental data set
setwd("C:/rprocessing/converted/posmzxmlfiles")
mzXMLpath <- dir(getwd())
getwd()
mzXMLfiles.fullnames <- dir(mzXMLpath,full.names=TRUE,pattern="\\.mzXML$",recursive=TRUE)
show(mzXMLfiles.fullnames)
mzXMLfiles.shortnames <- dir(mzXMLpath,full.names=FALSE,pattern="\\.mzXML$",recursive=TRUE)
show(mzXMLfiles.shortnames)
foldernames <- dir("C:/rprocessing/converted/posmzxmlfiles")
show(foldernames)
outputfilenames <- paste(sub(".mzXML", "", mzXMLfiles.fullnames), ".peakml", sep="")
show(outputfilenames)

## Extracting peaks with centWave algorithm from XCMS

for (i in 1:length(mzXMLfiles.fullnames))
{
   xset <- xcmsSet(
         mzXMLfiles.fullnames[i], method='centWave', ppm=1, peakwidth=c(10,50),
         snthresh=3, prefilter=c(3,100), integrate=1, mzdiff=-0.00005,
         verbose.columns=TRUE,fitgauss=FALSE
      )
   PeakML.xcms.write.SingleMeasurement(
         xset=xset, filename=outputfilenames[i],
         ionisation="detect", addscans=30, writeRejected=FALSE
      )
}




## Combine biological replicates

MainClasses <- dir ()
dir.create ("combined")

for (i in 1:length(MainClasses))
{
   FILESf <- dir(MainClasses[i],full.names=TRUE,pattern="\\.peakml$",recursive=TRUE)
   OUTPUTf <- paste("combined/",MainClasses[i],".peakml",sep="")
   mzmatch.ipeak.Combine(i=paste(FILESf, collapse=","), v=T, rtwindow=600,o=OUTPUTf, combination="set",ppm=5, label=paste(MainClasses[i], sep=""))
}


## Combine different conditions

INPUTDIR <- "combined"
FILESf <- dir (INPUTDIR,full.names=TRUE,pattern="\\.peakml$")
mzmatch.ipeak.Combine(
      i=paste(FILESf,collapse=","), v=T, rtwindow=10,
      o="final_combined.peakml", combination="set", ppm=5
   )



####### Intensity filter #######
mzmatch.ipeak.filter.SimpleFilter(
        i="final_combined.peakml",
        o="final_combined_intfiltered.peakml",
        minintensity=10000, v=T
     )


####### Gap filler #######
PeakML.GapFiller (
        filename = "final_combined_intfiltered.peakml",
        ionisation = "detect",
        Rawpath = NULL,
        outputfile = "final_combined_intfiltered_gapfilled.peakml",
        ppm = 0,
        rtwin = 0
     )

## Match related peaks

mzmatch.ipeak.sort.RelatedPeaks(
      i="final_combined_intfiltered_gapfilled.peakml", v=T,
      o="final_combined_intfiltered_gapfilled_related.peakml",
      basepeaks="final_combined_basepeaks.peakml",
      ppm=5, rtwindow=30
   )

## Identify peaks from databases

DBS <- dir(
      paste(.find.package("mzmatch.R"), "/dbs", sep=""),
      full.names=TRUE
   )
DBS
DBS <- paste(DBS[c(1,2)],collapse=",")
mzmatch.ipeak.util.Identify(
       i="final_combined_intfiltered_gapfilled_related.peakml", v=T,
       o="final_combined_IGFR_identified.peakml",
       ppm=5, databases=DBS
   )
mzmatch.ipeak.util.Identify(
      i="final_combined_basepeaks.peakml", v=T,
      o="final_combined_basepeaks_identified.peakml",
      ppm=5, databases=DBS
   )

   ####### Filter on identifications #######

mzmatch.ipeak.filter.SimpleFilter(
     i="final_combined_IGFR_identified.peakml",
     o="final_combined_IGFR_identified_only.peakml",
     annotations="identification", v=T
   )


## Convert to text

mzmatch.ipeak.convert.ConvertToText(
      i="final_combined_IGFR_identified_only.peakml", o="final_combined_related_identified_only.txt", databases=DBS, annotations="identification", v=T
  )

## Organising negative experimental data set
setwd("C:/rprocessing/converted/negmzxmlfiles")
mzXMLpath <- dir(getwd())
getwd()
mzXMLfiles.fullnames <- dir(mzXMLpath,full.names=TRUE,pattern="\\.mzXML$",recursive=TRUE)
show(mzXMLfiles.fullnames)
mzXMLfiles.shortnames <- dir(mzXMLpath,full.names=FALSE,pattern="\\.mzXML$",recursive=TRUE)
show(mzXMLfiles.shortnames)
foldernames <- dir("C:/rprocessing/converted/negmzxmlfiles")
show(foldernames)
outputfilenames <- paste(sub(".mzXML", "", mzXMLfiles.fullnames), ".peakml", sep="")
show(outputfilenames)

## Extracting peaks with centWave algorithm from XCMS

for (i in 1:length(mzXMLfiles.fullnames))
{
   xset <- xcmsSet(
         mzXMLfiles.fullnames[i], method='centWave', ppm=1, peakwidth=c(10,50),
         snthresh=3, prefilter=c(3,100), integrate=1, mzdiff=-0.00005,
         verbose.columns=TRUE,fitgauss=FALSE
      )
   PeakML.xcms.write.SingleMeasurement(
         xset=xset, filename=outputfilenames[i],
         ionisation="detect", addscans=30, writeRejected=FALSE
      )
}




## Combine biological replicates

MainClasses <- dir ()
dir.create ("combined")

for (i in 1:length(MainClasses))
{
   FILESf <- dir(MainClasses[i],full.names=TRUE,pattern="\\.peakml$",recursive=TRUE)
   OUTPUTf <- paste("combined/",MainClasses[i],".peakml",sep="")
   mzmatch.ipeak.Combine(i=paste(FILESf, collapse=","), v=T, rtwindow=600,o=OUTPUTf, combination="set",ppm=5, label=paste(MainClasses[i], sep=""))
}


## Combine different conditions

INPUTDIR <- "combined"
FILESf <- dir (INPUTDIR,full.names=TRUE,pattern="\\.peakml$")
mzmatch.ipeak.Combine(
      i=paste(FILESf,collapse=","), v=T, rtwindow=10,
      o="final_combined.peakml", combination="set", ppm=5
   )



####### Intensity filter #######
mzmatch.ipeak.filter.SimpleFilter(
        i="final_combined.peakml",
        o="final_combined_intfiltered.peakml",
        minintensity=10000, v=T
     )


####### Gap filler #######
PeakML.GapFiller (
        filename = "final_combined_intfiltered.peakml",
        ionisation = "detect",
        Rawpath = NULL,
        outputfile = "final_combined_intfiltered_gapfilled.peakml",
        ppm = 0,
        rtwin = 0
     )

## Match related peaks

mzmatch.ipeak.sort.RelatedPeaks(
      i="final_combined_intfiltered_gapfilled.peakml", v=T,
      o="final_combined_intfiltered_gapfilled_related.peakml",
      basepeaks="final_combined_basepeaks.peakml",
      ppm=5, rtwindow=30
   )

## Identify peaks from databases

DBS <- dir(
      paste(.find.package("mzmatch.R"), "/dbs", sep=""),
      full.names=TRUE
   )
DBS
DBS <- paste(DBS[c(1,2)],collapse=",")
mzmatch.ipeak.util.Identify(
       i="final_combined_intfiltered_gapfilled_related.peakml", v=T,
       o="final_combined_IGFR_identified.peakml",
       ppm=5, databases=DBS
   )
mzmatch.ipeak.util.Identify(
      i="final_combined_basepeaks.peakml", v=T,
      o="final_combined_basepeaks_identified.peakml",
      ppm=5, databases=DBS
   )

   ####### Filter on identifications #######

mzmatch.ipeak.filter.SimpleFilter(
     i="final_combined_IGFR_identified.peakml",
     o="final_combined_IGFR_identified_only.peakml",
     annotations="identification", v=T
   )


## Convert to text

mzmatch.ipeak.convert.ConvertToText(
      i="final_combined_IGFR_identified_only.peakml", o="final_combined_related_identified_only.txt", databases=DBS, annotations="identification", v=T
  )


