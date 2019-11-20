# Text Mining Product Reviews  
  

<hr>

## Project Description  

This project seeks to uncover insights on consumer buying habits and size of customer base from Amazon product reviews. Primarily, this project provides a user several visualizations created from text data to help them derive various insights.  

## Other Project Goals

- Work with and develop a basic Shiny app in RStudio
- Refresh on text mining and text data manipulation & analysis skills

<hr>

## Software utilized

* Mac OSx Mojave version 10.14.6
* R (for Mac) version 3.6.0 (2019-04-26) "Planting of a Tree"
* RStudio version 1.2.1335

## Software installation

* Download R at:  https://www.r-project.org.
* Download RStudio at:  https://rstudio.com/products/rstudio/download/.

## R packages utilized

* tidyverse version 1.2.1  
* lubridate version 1.7.4  
* tidytext version 0.2.2  
* textdata version 0.3.0  
* tm version 0.7-6  
* ggraph version 2.0.0  
* wordcloud version 2.6  
* RColorBrewer version 1.1-2  
* syuzhet version 1.0.4  
* shiny version 1.4.0  
* shinythemes version 1.1.2  
* gridExtra version 2.3  
* plyr version 1.8.4  

## R package installation

### Packages available through CRAN repository

* You can check to see if a package is available directly from a CRAN repository at:  https://cran.r-project.org/web/packages/available_packages_by_name.html.  

* Use CTRL+F (Windows) or CMD+F (Mac) to quickly search a package name.

* To install the package in R or RStudio use the `install.package("package_name")` command in the console.

### Packages not available through the CRAN repository  

* If a package is not available on the CRAN repository, search for the package by name with your favorite search engine. Many packages are available through individual GitHub pages or R-Forge. 

* If you have to install a package from a site other than a CRAN repository, it's recommended to search for that package's installation instructions. 

<hr>

## About this repository

### Included files

**json_to_csv.R**  
    - This script reads `.json` data files and converts them to `.csv` files.  
    - Users MUST download and save the `.json` data files in their respective working directory prior to executing this script.  

**global.R**  
    - This is a global file for the Shiny application.  
    - It loads relevant/necessary packages, performs select variable factoring, and loads the data set(s) for use by the Shiny application.  

**ui.R**  
    - This file holds the Shiny application user interface code.  
    - It sets the template/structure for the application.  

**server.R**  
    - This file holds the Shiny application server code.  
    - It performs all of the relevent calculations and plotting.  

### Files not included  

**Data file(s)**  
    - The `.json` data files can be downloaded from http://jmcauley.ucsd.edu/data/amazon/. Download the 5-core data sets for "Musical Instruments" and "Office Products" to your respective working directory.  

<hr>

## App execution  

1) Download the appropriate `.json` data sets and save them in a folder called "JSON_files" inside of your project directory/folder
2) Open RStudio  
3) Set the working directory to your project directory/folder  
4) In the console, type `source("json_to_csv.R")`  
5) Check your project directory/folder to ensure that you have two `.csv` data files
6) Open the following files in the RStudio editor:  
    - global.R  
    - ui.R  
    - server.R  
7) To run the app:
    a) If you alread have the Shiny package loaded, then type `runApp()` in the console and hit ENTER
    b) If the Shiny package IS NOT already loaded, then click the $Run App$ button locoated at the top-right of the RStudio editor 

<hr>  

## Important notes

* Because of the time it takes to parse text data in this app, there are four tabs that take a while for the visualizations to load:
    - "Trends" tab  
    - "Product Insights" tab  
    - "General Sentiments" tab  
    - "Topic Insights" tab  
    
* The "Trends" tab does NOT contain a progress indicator on the app itself. Instead, while the app is open, check/monitor your RStudio console for execution progress.  

* For the "Product Insights", "General Sentiments", and "Topic Insights" tabs, progress indicators were included to let users know that the app is working on developing the appropriate graphic/output.   

<hr>

## About the app

### App layout  

The app consists of tabbed pages. Once launched the app opens to the "Data" tab. To navigate, simply click on each tab name to switch between pagess. Further information about each page follows below.  

### App page tabs  

#### Data page  

* The "Data" page provides users with simple information about the data set that is being examined. The main panel provides some summary information and a sample view of the data set. To view the full data set in the original (`.json`) or transformed (`.csv`) forms, users are encouraged to use a different software tool, such as Microsoft Excel or their preferred text editor.  
* Users have the option to select a data set by clicking on one of the radio buttons in the side panel on the left of the page. The default data set is the first/top data set listed. The selected data set is used by all of the remaining tabs to produce information/visualizations.  
* A data set can ONLY be selected on the "Data" page.

#### Frequencies page  

* The intent of the "Frequencies" page is to investigate when customers post reviews during a particular time period and identify associate peaks and valleys.  
* It only shows an aggregated view for a corresponding time period. At this time it does not include the functionality for focused inspection (i.e., it will not show reviews posted by month for a specific year).  
* Users can select which, or all, time period to view by selecting the appropriate check-box located in the left side panel.  

#### Distributions page  

* The "Distributions" page provides insight on product rating profiles over a particular time period.  
* It only shows an aggregated view for a corresponding time period. At this time it does not include the functionality for focused inspection (i.e., it will not show rating profiles by month for a specific year).  
* Users can select which, or all, time period to view by selecting the appropriate check-box located in the left side panel.  

#### Trends page  

* The "Trends" page seeks to examine fluctuations in standard deviations of review sentiment scores over particular time periods. Considering the plots on the "Frequencies" and "Distributions" pages one will note the increased number of posted reviews, likely a result of increased comfort & use of online shopping. By examining the trend of standard deviations these plots seek to see if there is any substantial trend change of overall sentiment score distribution shapes across time periods/units.  
* It only shows an aggregated view for a corresponding time period. At this time it does not include the functionality for focused inspection.  
* Users can select which, or all, time period to view by selecting the appropriate check-box located in the left side panel.   

#### Product Insights page  

* The "Product Insights" page seeks to provide insight on popular products and/or brands based on the number of reviews.  
* It displays the top 15 bigrams and trigrams found using all posted reviews.  

#### General Sentiments page  

* The "General Sentiments" page provides insight on general, overall customer sentiment across product reviews.  
* The top portion of the page displays four charts on negating words used in text reviews.  
* The bottom portion shows a word network of bigram clusters to show key word relationships.  

#### Topic Insights page  

* The "Topic Insights" page provides insight on the most frequent terms used across all reviews via a word cloud. This can help to potentially identify popular products and/or brands.  
* The page displays a word cloud of the 75 most frequent terms in the data set.

<hr>

## Author(s)
G. Conway


## Acknowledgements/Citations

**Ups and downs: Modeling the visual evolution of fashion trends with one-class collaborative filtering**  
R. He, J. McAuley  
WWW, 2016  

**Image-based recommendations on styles and substitutes**  
J. McAuley, C. Targett, J. Shi, A. van den Hengel  
SIGIR, 2015  