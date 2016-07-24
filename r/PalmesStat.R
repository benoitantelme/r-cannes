# --------- cleaning variables and connections -----------------
closeAllConnections()
rm(list=ls())


# --------- reading csv data -----------------
path = "D:/data/prog/R/CannesData/CannesLight.xlsx"
library(readxl)
myData = read_excel(path, "Combined")
#warnings()



# --------- cleaning data frame ------------
source("r/Utils.R")
myNewData <- cleanCombinedDataFrame(myData)
rm(myData)
str(myNewData)


# --------- google library -----------------
library(RJSONIO)
library(googleVis)


# --------- plotting palmes in map -----------------
cleanedNominations <- createCleanNominations(myNewData, TRUE)
plotDataFrame(cleanedNominations, "Country", "Nominations", "Nominations Per Country", 1280, 800)



# --------- plotting genre per decade as pie -----------------

# TODO finish the merge method
#pieCharts <- mergeGPDPiecharts(myNewData)

firstPie <- createGenresPerDecadePieChart(myNewData, 1990, 400)
secondPie <- createGenresPerDecadePieChart(myNewData, 2000, 400)
pies <- gvisMerge(firstPie,secondPie, horizontal=TRUE) 



plot(pies)



