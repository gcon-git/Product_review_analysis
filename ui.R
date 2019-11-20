####################################################
##                                                ##
## Project: Text Mining Product Reviews           ##
## Author: Gary Conway                            ##
##                                                ##
####################################################

## data_sets ------------------------------------------------------------------
available_sets <- c(
    "Musical Instruments" = "mi",
    "Office Products" = "op"
)

## Main function --------------------------------------------------------------
fluidPage(  
    
    ## app theme  ----------------------------------------
    theme = shinytheme("darkly"), 
    
    ## name of main page ---------------------------------
    "Text Mining Product Reviews ",
    
    ## title panel ---------------------------------------
    titlePanel("Insights of Amazon Reviews"), 

    ## TABBED pages ###### ----------------------------------------------------
    tabsetPanel(
        ## Data tab ===========================================================
        tabPanel("Data",
                 # sidebar panel -------------------------
                 sidebarPanel(
                     radioButtons("filename",
                                 label = "Choose one",
                                 choices = available_sets,
                                 ),
                     br(),
                     br(),
                     br(),
                     br(),
                     br(),
                     br(),
                     br(),
                     br(),
                     br(),
                     br(),
                     p("Data sets used in this app are the 5-core versions obtained from the following website:"),
                     p("http://jmcauley.ucsd.edu/data/amazon/"),
                     width = 3
                     ),
                 # numReviews panel -------------------------
                 conditionalPanel(
                     "input.filename != ''",
                     h5("Total Number of Reviews"),
                     textOutput("numReviews")
                     ),
                 # uniqueProd panel -------------------------
                 conditionalPanel(
                     "input.filename != ''",
                     h5("Number of Unique Products"),
                     textOutput("uniqueProd")
                     ),
                 # whichYears panel -------------------------
                 conditionalPanel(
                     "input.filename != ''",
                     h5("Years covered"),
                     textOutput("whichYears")
                 ),
                 br(),
                 br(),
                 p(strong("Here is a sample of what the review data looks like for each set. Maximize the app window or your browser for optimal viewing.")),
                 br(),
                 br(),
                 # table the output in main panel -----------
                 mainPanel(
                     tableOutput('dataset')
                     )
                 ), # closure for Data tabPanel
        ## Frequencies tab ====================================================
        tabPanel("Frequencies",
                 # sidebar panel ----------------------------
                 sidebarPanel(
                     p("The plots selected show the number of reviews over a particular date/time reference."),
                     br(),
                     p("Please select which plots to view:"),
                     br(),
                     checkboxInput("plotYear", "By Year", value = T),
                     checkboxInput("plotMonth", "By Month", value = F),
                     checkboxInput("plotDOM", "By Day of the Month", value = F),
                     checkboxInput("plotDOW", "By Day of the Week", value = F),
                     br(),
                     br(),
                     textOutput("selectedData")
                     ),
                 # main panel -------------------------------
                 mainPanel(
                     plotOutput("allPlots", height = "750px")
                     )
                 ), # closure for Frequencies tabPanel
        ## Distributions tab ==================================================
        tabPanel("Distributions",
                # sidebar panel -----------------------------
                 sidebarPanel(
                     p("The plots show the ratings profiles over a particular date/time reference."),
                     br(),
                     p("Please select which plots to view:"),
                     br(),
                     checkboxInput("distroYear", "By Year", value = T),
                     checkboxInput("distroMonth", "By Month", value = F),
                     checkboxInput("distroDOM", "By Day of the Month", value = F),
                     checkboxInput("distroDOW", "By Day of the Week", value = F),
                     br(),
                     br(),
                     textOutput("selectedData2")
                 ),
                # main panel --------------------------------
                mainPanel(
                    plotOutput("allDistros", height = "750px")
                    )
                ), # closure for Distributions tab panel
        ## Trends tab =========================================================
        tabPanel("Trends",
                 ## sidebar panel ---------------------------
                 sidebarPanel(
                     p("The plots displayed show the trend changes of review sentiments based on their standard deviations."),
                     br(),
                     p("Please select which plots to view:"),
                     br(),
                     checkboxInput("trendYear", "By Year", value = T),
                     checkboxInput("trendMonth", "By Month", value = F),
                     checkboxInput("trendDOM", "By Day of the Month", value = F),
                     checkboxInput("trendDOW", "By Day of the Week", value = F),
                     br(),
                     br(),
                     p("Please be patient while the plot(s) load."),
                     br(),
                     br(),
                     textOutput("selectedData3")
                     ),
                 ## main panel ------------------------------
                 mainPanel(
                     plotOutput("alltrends", height = "750px")
                     )
                 ), # closure for Trends tabPanel
        ## Product Insights tab ===============================================
        tabPanel("Product Insights",
                 ## sidebar panel ---------------------------
                 sidebarPanel(
                     p("The plots shown display the top 15 bigrams and trigrams."),
                     p("These are intended to give some insight into popular products based on the reviews submitted."),
                     br(),
                     br(),
                     p("Please be patient while the plot(s) load."),
                     br(),
                     br(),
                     textOutput("selectedData4")
                     ),
                 ## main panel -----------------------------
                 mainPanel(
                     plotOutput("bigram"),
                     plotOutput("trigram")
                     )
                 ), # closure for Product Insights tabPanel
        ## General Sentiments tab =============================================
        tabPanel("General Sentiments",
                 ## side panel -----------------------------
                 sidebarPanel(
                     p("The plots shown provide general insight into the overall sentiment of the reviews."),
                     p("Looking at plots involving negation words can indicate if the reviews are overwhelmingly positive or negative in nature."),
                     br(),
                     p("The bigram network plot provides insight on bigram relationships to better understand the context in which words are used in the reviews."),
                     br(),
                     br(),
                     p("Please be patient while the plot(s) load."),
                     br(),
                     br(),
                     textOutput("selectedData5")
                     ),
                 ## main panel -----------------------------
                 mainPanel(
                     plotOutput("negated"),
                     plotOutput("network")
                     )
                 ), # closure for General Sentiments tabPanel
        ## Topic Insights tab =================================================
        tabPanel("Topic Insights",
                 ## side panel -----------------------------
                 sidebarPanel(
                     p("Word cloud of the most frequent terms across all reviews."),
                     br(),
                     p("The word cloud shows the top 75 words from all of the reviews."),
                     br(),
                     br(),
                     p("Please be patient while the plot(s) load."),
                     br(),
                     br(),
                     textOutput("selectedData6")
                     ),
                 ## main panel -----------------------------
                 mainPanel(
                     plotOutput("cloud", height = "700px")
                     )
                 ) # closure for Topic Insights tabPanel
        
    ) # closure for tabsetPanel()
    
) # closure for fluidPage()