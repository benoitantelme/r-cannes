# --------- cleaning variables and connections -----------------
closeAllConnections()
rm(list=ls())


# --------- reading csv data -----------------
path = "D:/data/prog/R/CannesData/CannesLight.xlsx"
library(readxl)
myData = read_excel(path, "Combined")


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
plotDfAsGeoChart(cleanedNominations, "Country", "Nominations", "Nominations Per Country", 1280, 800)



# --------- plotting genre per decade as pie -----------------
palmesData <- filterPalmes(myNewData, TRUE)
dataPerDecades = split(palmesData, f = palmesData$`Cannes decade`)
oderedDecades <- sort(unique(myNewData$`Cannes decade`))
pieCharts <- mergePiecharts(dataPerDecades, oderedDecades, 350)
plot(pieCharts)
