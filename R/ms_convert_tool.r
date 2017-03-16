################ ms convert tool #############
setwd("c:/rprocessing/rawdata")

msconvert <- c("C:/pwiz/msconvert.exe")
FILES <- list.files(recursive=TRUE, full.names=TRUE, pattern="\\.raw")
show(FILES)
for (i in 1:length(FILES))
{system (paste(msconvert," --mzXML --filter \"peakPicking true 1\" --filter \"polarity positive\" -o C:/rprocessing/converted/posmzxmlfiles -v",FILES[i]))}
for (i in 1:length(FILES))
{system (paste(msconvert," --mzXML --filter \"peakPicking true 1\" --filter \"polarity negative\" -o C:/rprocessing/converted/negmzxmlfiles -v",FILES[i]))}

