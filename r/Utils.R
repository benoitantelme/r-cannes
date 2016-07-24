
keepFirstWord <- function(string){
  # return the first word of a string
  if(is.character(string))
    string <- strsplit(string,split=" ")[[1]][1]
  
  return(string)
}

filterPalmes <- function(dataFrame, onlyPalm){
  #keep only palmes d'or nominations if desired
  if(length(dataFrame) > 0){
    if(onlyPalm == TRUE){
      dataFrame <- dataFrame[dataFrame$`Palme d'Or` == 1,]
    }
  }
  
  return(dataFrame)
}

filterDecades <- function(dataFrame, decade){
  # filter data frame by specified decade
  if(length(dataFrame) > 0){
    if(decade != -1){
      dataFrame <- dataFrame[dataFrame$`Cannes decade` == decade,]
    }
  }
  
  return(dataFrame)
}

createCountDataFrame <- function(vector, fieldName, quantityName){
  # create a data frame containing the count of each of a (char) vector member
  if(length(vector) > 0){
    table <- table(vector)
    dataFrame <- as.data.frame(table)
    colnames(dataFrame) <- c(fieldName, quantityName)
  }
  else{
    dataFrame <- data.frame(none=character(), stringsAsFactors=FALSE) 
  }
  
  return(dataFrame)
}

createCleanNominations <- function(dataFrame, onlyPalm){
  # create a data frame containing the number of nominations per country. Can filter to keep only palmes
  dataFrame <- filterPalmes(dataFrame, onlyPalm)
  cleanedCountries <- sapply(dataFrame$`IMDb Country`, keepFirstWord)
  countriesDf <- createCountDataFrame(cleanedCountries, "Country", "Nominations")
  
  return(countriesDf)
}

createCleanGenresNominations <- function(dataFrame, onlyPalm){
  # create a data frame containing the number of nominations per genres. Can filter to keep only palmes
  dataFrame <- filterPalmes(dataFrame, onlyPalm)
  genreDataframe <- createCountDataFrame(dataFrame$genre, "Genre", "Nominations")
  
  return(genreDataframe)
}

createGenresPerDecadePieChart <- function(dataFrame, decade, diameter){
  #A pie chart, showing the nominations per genre for a decade 
  cleanedPerDecade <- filterDecades(dataFrame, decade)
  pie <- createGenresPieChart(cleanedPerDecade, decade, diameter)
  
  return(pie)
}

createGenresPieChart <- function(dataFrame, title, diameter){
  #A pie chart, showing the nominations per genre 
  genres <- createCountDataFrame(dataFrame$genre, "Genre", "Nominations")
  pie <- gvisPieChart(genres, labelvar = "Genre", numvar = "Nominations",options=list(gvis.editor= title, width=diameter, height=diameter))
  
  return(pie)
}

mergeGPDPiecharts <- function(dataFrame){
  #TODO finish and correct
  
  # create a merge of genre per decades pie chartes
  palmesData <- filterPalmes(dataFrame, TRUE)
  dataPerDecades = split(palmesData, f = palmesData$`Cannes decade`)
  
  #issue with result format with mapply
  #res <- mapply(createGenresPieChart, dataPerDecades, oderedDecades, 400) 
  
  oderedDecades <- sort(unique(dataFrame$`Cannes decade`))
  nbrOfDecades <- length(dataPerDecades)
  pivot <- floor((nbrOfDecades -1) / 2) + 1
  
  firstPie <- createGenresPieChart(dataPerDecades[2], oderedDecades[2], 400)
  
  for (i in 3:pivot){
    newPie <- createGenresPieChart(dataPerDecades[i], oderedDecades[i], 400)
    firstPie <- gvisMerge(firstPie,newPie, horizontal=TRUE)
  }
  
  secondPie <- createGenresPieChart(dataPerDecades[pivot + 1], oderedDecades[pivot + 1], 400)
  
  for (i in pivot + 2:nbrOfDecades-1){
    newPie <- createGenresPieChart(dataPerDecades[i], oderedDecades[i], 400)
    secondPie <- gvisMerge(secondPie,newPie, horizontal=TRUE)
  }
  
  pies <- gvisMerge(firstPie,secondPie, horizontal=FALSE) 
  
  return(pies)
}

plotDataFrame <- function(df, locationVarName, colorVarName, title, widthParam, heightParam){
  # Plot a data frame with gvis, using from light to dark blue coloring, into a geo chart using the location variable and color (intensity) variable
  countries_plot <- gvisGeoChart(df, locationvar = locationVarName, colorvar = colorVarName, 
                                 options=list(gvis.editor= title, projection="kavrayskiy-vii",
                                              width=widthParam, height=heightParam, colors="['#0099C6', '#3366CC']"))
  plot(countries_plot)
}

cleanCombinedDataFrame <- function(myDataFrame){
  # clean the data frame, removing useless sheets
  myDataFrame$`_pageUrl` <- NULL
  myDataFrame$`IMDb ID` <- NULL
  myDataFrame$`IMDb Year` <- NULL
  myDataFrame$release_date <- NULL
  
  return(myDataFrame)
}
