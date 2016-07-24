
# --------- general functions -----------------

keepFirstWord <- function(string){
  # return the first word of a string
  
  if(is.character(string))
    string <- strsplit(string,split=" ")[[1]][1]
  
  return(string)
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

mergePiecharts <- function(dataPerDecades, orderedDecades, size){
  # create a merge of genre per decades pie charts
  # Separate the charts in two rows and then merge them vertically
  
  nbrOfDecades <- length(dataPerDecades)
  separator <- floor(nbrOfDecades/ 2) + 1
  
  firstLine <- createPieChartsRow(dataPerDecades, oderedDecades, 1, separator, size)
  secondLine <- createPieChartsRow(dataPerDecades, oderedDecades, separator+1, nbrOfDecades, size)
  
  pies <- gvisMerge(firstLine,secondLine, horizontal=FALSE) 
  
  return(pies)
}

createPieChartsRow <- function(dataPerDecades, oderedDecades, start, stop, size){
  #create a set of pie charts, merged horizontaly
  #TODO look at the mapply case or an alternative, so far issue with mapply return format
  #res <- mapply(createGenresPieChart, dataPerDecades, oderedDecades, size) 
  
  initialPie <- createGenresPieChart(dataPerDecades[[start]], oderedDecades[start], size)
  
  for (i in (start + 1):stop){
    newPie <- createGenresPieChart(dataPerDecades[[i]], oderedDecades[i], size)
    initialPie <- gvisMerge(initialPie,newPie, horizontal=TRUE)
  }
  
  return(initialPie)
}

# --------- Data related functions -----------------

filterPalmes <- function(dataFrame, onlyPalm){
  #keep only palmes d'or nominations if desired
  
  if(length(dataFrame) > 0){
    if(onlyPalm == TRUE){
      dataFrame <- dataFrame[dataFrame$`Palme d'Or` == 1,]
    }
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

cleanCombinedDataFrame <- function(myDataFrame){
  # clean the data frame, removing useless sheets
  
  myDataFrame$`_pageUrl` <- NULL
  myDataFrame$`IMDb ID` <- NULL
  myDataFrame$`IMDb Year` <- NULL
  myDataFrame$release_date <- NULL
  
  return(myDataFrame)
}

# --------- plotting functions -----------------

plotDfAsGeoChart <- function(df, locationVarName, colorVarName, title, widthParam, heightParam){
  # Plot a data frame with gvis, using from light to dark blue coloring, into a geo chart using the location variable and color (intensity) variable
  
  countries_plot <- gvisGeoChart(df, locationvar = locationVarName, colorvar = colorVarName, 
                                 options=list(gvis.editor= title, projection="kavrayskiy-vii",
                                              width=widthParam, height=heightParam, colors="['#0099C6', '#3366CC']"))
  plot(countries_plot)
}

createGenresPieChart <- function(dataFrame, title, size){
  #A pie chart, showing the nominations per genre 
  
  genres <- createCountDataFrame(dataFrame$genre, "Genre", "Nominations")
  pie <- gvisPieChart(genres, labelvar = "Genre", numvar = "Nominations",options=list(gvis.editor= title, width=size, height=size))
  
  return(pie)
}
