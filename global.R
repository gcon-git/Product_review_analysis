####################################################
##                                                ##
## Project: Text Mining Product Reviews           ##
## Author: Gary Conway                            ##
##                                                ##
####################################################

## load packages --------------------------------------------------------------
library(lubridate)
library(tidyverse)
library(tidytext)
library(textdata) # needed for AFINN lexicon
library(tm)
library(ggraph)
library(wordcloud)
library(RColorBrewer)
library(syuzhet)
library(shiny)
library(shinythemes)
library(gridExtra)

# preload data sets -----------------------------------------------------------
#   (This helps the app run faster) 

mi <- read_csv("Musical_Instruments.csv", col_names = TRUE)
op <- read_csv("Office_Products.csv", col_names = TRUE)


# function to fix the classes of select columns ------------------------------

fixit <- function(x){
    x$reviewDay <- factor(x$reviewDay)
    x$reviewMonth <- factor(x$reviewMonth)
    x$reviewYear <- factor(x$reviewYear)
    x$reviewWkDay <- factor(x$reviewWkDay, levels = c("Sun","Mon","Tue","Wed",
                                                      "Thu","Fri","Sat"))
    x$overall <- as.integer(x$overall)
    return(x)
}

# fix the data sets -----------------------------------------------------------

mi <- fixit(mi)
op <- fixit(op)
