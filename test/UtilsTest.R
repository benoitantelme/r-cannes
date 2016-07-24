library(RUnit)
source("r/Utils.R")

test.keepFirstWord <- function()
{
  checkEquals("firstword", keepFirstWord("firstword of a sentence"))
  checkEquals("firstword", keepFirstWord("firstword"))
  checkEquals("firstword-of", keepFirstWord("firstword-of a sentence"))
  
  checkTrue(is.na(keepFirstWord("")))
  
  #check odd values do not crash
  keepFirstWord(NA)
  keepFirstWord(NULL)
}


test.filterPalmes <- function()
{
  df <- cbind.data.frame(c("France", "Germany"), c(1, 0))
  colnames(df) <- c("IMDb Country", "Palme d'Or")
  
  palmes <- filterPalmes(df, TRUE)
  checkEquals(1, nrow(palmes))
  
  all <- filterPalmes(df, FALSE)
  checkEquals(2, nrow(all))
  
  #check null vector does not break
  nullVector <- vector()
  nullNoCheck <- filterPalmes(nullVector, 1)
}


test.filterDecades <- function()
{
  df <- cbind.data.frame(c("France", "Germany"), c(1, 0))
  colnames(df) <- c("IMDb Country", "Cannes decade")
  
  one <- filterDecades(df, 1)
  checkEquals(1, nrow(one))
  
  none <- filterDecades(df, 2)
  checkEquals(0, nrow(none))
  
  #check no filtering
  minusOne <- filterDecades(df, -1)
  checkEquals(2, nrow(minusOne))
  
  #check null vector does not break
  nullVector <- vector()
  nullNoCheck <- filterDecades(nullVector, 1)
}



test.createCountDataFrame <- function()
{
  vector <- c("France", "Germany", "UK", "France", "HK", "China", "USA", "HK")
  df <- createCountDataFrame(vector, "name", "count")
  #check 6 rows, 2 times France, 
  checkEquals(6, nrow(df))
  checkEquals(2, df[df$name == "France",]$count)
  
  nullVector <- vector()
  nullDf <- createCountDataFrame(nullVector)
  #check we got a data frame with no rows
  checkEquals(TRUE, is.data.frame(nullDf))
  checkEquals(0, nrow(nullDf))
}


test.createCleanNominations <- function()
{
  df <- cbind.data.frame(c("France US", "Germany", "UK Norway", "France", "HK China", "China", "USA", "HK"), c(1, 0, 0, 0, 1, 0, 1, 0), stringsAsFactors=FALSE)
  colnames(df) <- c("IMDb Country", "Palme d'Or")
  
  #only palmes
  palmes <- createCleanNominations(df, TRUE)
  checkEquals(3, nrow(palmes))
  
  #everything
  all <- createCleanNominations(df, FALSE)
  checkEquals(6, nrow(all))
  
  # no more additional countries in list
  checkEquals(rep(FALSE, 6), grepl("France US", all$Country))
}


test.cleanCombinedDataFrame <- function()
{
  df <- data.frame(c(2, 3), c(2, 3), c(2, 3), c(2, 3), c(2, 3), c(2, 3))
  colnames(df) <- c("a", "_pageUrl", "b", "IMDb ID", "IMDb Year", "release_date")
  checkEquals(6, length(df))
  
  #check function cleans the df
  df2 <- cleanCombinedDataFrame(df)
  checkEquals(2, length(df2))
  
  #check absence of columns does not break
  df <- data.frame(c(2, 3), c(2, 3), c(2, 3))
  colnames(df) <- c("a", "IMDb Year", "release_date")
  df3 <- cleanCombinedDataFrame(df)
  checkEquals(1, length(df3))
}


