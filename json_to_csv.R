####################################################
##                                                ##
## Project: Text Mining Product Reviews           ##
## Author: Gary Conway                            ##
##                                                ##
####################################################

## Recommendation(s) ----------------------------------------------------------
## Download the .json data files from http://jmcauley.ucsd.edu/data/amazon/ 
##      first and save them to your computer. This reduces the number of "calls"
##      to the site where the data resides.

## About this script ----------------------------------------------------------
## To save on data access times in the related Shiny app, this script reads 
##      the .json files from your local directory, performs some data 
##      wrangling on all of the files, and then writes the tables to .csv files.
##
##  The corresponding .csv files are/were quicker and easier to manipulate by 
##      the relevant code found in the global.R and server.R script files of 
##      this project


# load packages
library(tidyverse)
library(lubridate)

# function to wrangle .json data
wrangle <- function(fileName){
    
    # local folder/directory where the .json files were saved
    folder <- "JSON_files"
    
    filePath <- paste(folder, fileName, sep = "/")
    
    # use jsonlite package to read_in the .json data
    #   - type "?jsonlite::stream_in" in the console to see the help page
    #       for the stream_in() function
    dat <- jsonlite::stream_in(file(filePath), pagesize = 10000)
    
    # rename "asin" column to "productID"
    colnames(dat)[colnames(dat) == "asin"] <- "productID"
    
    # drop/remove "reviewerID", "reviewerName", and "helpful" columns as they
    #   are not used/needed for this project
    dat <- dat[, -c(1, 3, 4)]
    
    # change "reviewDate" from a text class to month-day-year Date class
    dat$reviewDate <- mdy(dat$reviewTime)
    
    # extract specific date elements from "reviewDate" column
    dat <- dat %>%
        mutate(reviewMonth = month(dat$reviewDate),
               reviewDay = day(dat$reviewDate),
               reviewYear = year(dat$reviewDate),
               reviewWkDay = wday(dat$reviewDate, label = TRUE)
        )
    
    # drop/remove "unixReviewTime" and "reviewTime" columns - they are no 
    #   longer needed since we extracted and created new columns for date
    #   elements in the preceeding step
    dat <- dat[, -c(5, 6)]
    
    # get current data file names only - drop the "_5.json" suffix
    fileName <- unlist(str_split(fileName, "_5.json"))[1]
    
    # save the new file names with a ".csv" file extension
    newFile <- paste(fileName, ".csv", sep = "")
    
    # write the new .csv files to current/project working folder/directory
    write_csv(dat, newFile, append = FALSE)
}

wrangle("Musical_Instruments_5.json")
wrangle("Office_Products_5.json")

rm(wrangle)
