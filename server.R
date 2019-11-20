####################################################
##                                                ##
## Project: Text Mining Product Reviews           ##
## Author: Gary Conway                            ##
##                                                ##
####################################################

## main server function -----
shinyServer(
    
    function(input, output){
        
        ## read in data set based on radio button selection -----
        df <- reactive({
            get(input$filename)
        })
        
        #### Goes with Data Tab ------------------------------------------------
        ## return the number of rows in data to numReviews output object ----
        output$numReviews <- renderPrint({
            temp <- df()
            cat(nrow(temp))
        })
        
        ## return the number of unique products to uniqueProd output object ----
        output$uniqueProd <- renderPrint({
            temp <- df()
            cat(length(unique(temp$productID)))
        })
        
        ## return the range of years covered in the review set ----
        output$whichYears <- renderPrint({
            temp <- df()
            low <- levels(temp$reviewYear)[1]
            hi <- levels(temp$reviewYear)[length(levels(temp$reviewYear))]
            yearRange <- paste(low, hi, sep = "-")
            cat(yearRange)
        })
        
        ## render the data table for viewing ----
        output$dataset <- renderTable({
            temp <- df()
            temp$reviewDate <- format(temp$reviewDate, "%m-%d-%Y")
            head(temp)
        })
        
        #### Goes with Frequencies tab ----------------------------------------
        ## function ----
        reviewFreqByTime <- function(dataset, feature, xAxisTitle){
            
            temp <- dataset
            
            feature = enquo(feature) # this puts quotes around the variable
            
            temp <- temp %>%
                count(!!feature)    # !! removes the quotes from the text
            
            titleLabel <- paste("Number of Reviews by", xAxisTitle)
            
            ggplot(temp,
                   aes(x = !!feature, y = n, group = 1)) +
                geom_point(stat = 'summary', fun.y = sum) +
                stat_summary(fun.y = sum, geom = "line", colour = "steel blue") +
                scale_y_continuous("Number of Reviews") +
                theme(axis.text.x = element_text(angle = 90,
                                                 hjust = 1,
                                                 vjust = 0.7)) +
                labs(title = titleLabel) +
                xlab(xAxisTitle)
        }
        
        ## frequency plot by Year -----
        ptYr <- reactive({
            if (!input$plotYear) return(NULL)
            reviewFreqByTime(df(), reviewYear, "Year")
        })
        
        ## frequency plot by Month -----
        ptMo <- reactive({
            if (!input$plotMonth) return(NULL)
            reviewFreqByTime(df(), reviewMonth, "Month")
        })
        
        ## frequency plot by day of the month -----
        ptDOM <- reactive({
            if (!input$plotDOM) return(NULL)
            reviewFreqByTime(df(), reviewDay, "Day of the Month")
        })
        
        ## frequency plot by day of the week -----
        ptDOW <- reactive({
            if (!input$plotDOW) return(NULL)
            reviewFreqByTime(df(), reviewWkDay, "Day of the Week")
        })
        
        ## output the frequency plots according to input ----
        output$allPlots <- renderPlot({
            ptlist <- list(ptYr(), ptMo(), ptDOM(), ptDOW())
            todelete <- !sapply(ptlist, is.null)
            ptlist <- ptlist[todelete]
            
            if (length(ptlist) == 0) return(NULL)
            
            grid.arrange(grobs = ptlist, ncol = 1)
        })
        
        ## reflect the data set the user selected -----
        output$selectedData <- renderText({
            switch (input$filename,
                mi = paste("Data set:    ", "Musical Instruments"),
                op = paste("Data set:    ", "Office Products")
                )
        })
        
        #### Goes with Distributions tab --------------------------------------
        ## function -----
        distroByTime <- function(dataset, feature, plotTitle, xlabel){

            temp <- dataset
            feature <- enquo(feature)

            temp <- temp %>%
                group_by(!!feature, overall) %>%
                select(overall) %>%
                count()

            ggplot(temp, aes(!!feature, n, group = factor(overall))) +
                geom_line(aes(color = factor(overall))) +
                scale_x_discrete(xlabel) +
                scale_y_continuous("Number of Ratings") +
                theme(axis.text.x = element_text(angle = 90,
                                                 hjust = 1,
                                                 vjust = 0.7)) +
                labs(title = plotTitle,
                     color = "Rating")
        }

        ## distribution by year -----
        distYr <- reactive({
            if(!input$distroYear) return(NULL)
            distroByTime(df(), reviewYear, "Rating Profiles By Year", "Year")
        })

        ## distribution by Month -----
        distMo <- reactive({
            if(!input$distroMonth) return(NULL)
            distroByTime(df(), reviewMonth, "Rating Profiles By Month", "Month")
        })

        ## distribution by day of the month -----
        distDOM <- reactive({
            if(!input$distroDOM) return(NULL)
            distroByTime(df(), reviewDay, "Rating Profiles By Day", "Day of the Month")
        })

        ## distribution by day of the week -----
        distDOW <- reactive({
            if(!input$distroDOW) return(NULL)
            distroByTime(df(), reviewWkDay, "Rating Profiles By Week Day", "Day of the Week")
        })

        ## output the profile plots according to input -----
        output$allDistros <- renderPlot({
            ptlist <- list(distYr(), distMo(), distDOM(), distDOW())
            todelete <- !sapply(ptlist, is.null)
            ptlist <- ptlist[todelete]

            if (length(ptlist) == 0) return(NULL)

            grid.arrange(grobs = ptlist, ncol = 1)
        })
        
        ## show the data set that was selected -----
        output$selectedData2 <- renderText({
            switch (input$filename,
                    mi = paste("Data set:    ", "Musical Instruments"),
                    op = paste("Data set:    ", "Office Products")
            )
        })
        
        #### Goes with Trends tab ----------------------------------------
        
        ## get the sentiments by date -----
        sentiments <- reactive({
            other_df <- df()
            
            sent_list <- plyr::alply(other_df$reviewText, 1, get_sentences,
                               .progress = "text")
            
            sent_list_sentiment <- plyr::llply(sent_list, get_sentiment, 
                                         .progress = "text")
            sent_list_sentiment <- plyr::llply(sent_list_sentiment, sign)
            sent_list_sentiment <- unlist(lapply(sent_list_sentiment, sum))

            test <- other_df %>%
                mutate(overall_sentiment_score = sent_list_sentiment)

            sentByDate <- test %>%
                select(reviewDate, reviewYear, reviewMonth, reviewDay,
                   reviewWkDay, overall_sentiment_score) %>%
                arrange(reviewDate)

            return(sentByDate)
        })
        
        ## function for sentiment variance trend plots -----
        trendByTime <- function(dataset, feature, xAxisLabel){

            temp <- dataset

            feature <- enquo(feature)

            ggplot(temp, aes(!!feature, overall_sentiment_score)) +
                geom_point(aes(color = !!feature)) +
                stat_summary(fun.y = sd, color = "black", geom = "line", aes(group = 1)) +
                theme(legend.position = "none") +
                labs(title = "Overall Sentiment Score Variance Trend",
                     x = xAxisLabel)
        }

        ## trend plot by Year -----
        trYr <- reactive({
            if (!input$trendYear) return(NULL)
            trendByTime(sentiments(), reviewYear, "Year")
        })

        ## trend plot by Month -----
        trMo <- reactive({
            if (!input$trendMonth) return(NULL)
            trendByTime(sentiments(), reviewMonth, "Month")
        })

        ## trend plot by day of the month -----
        trDOM <- reactive({
            if (!input$trendDOM) return(NULL)
            trendByTime(sentiments(), reviewDay, "Day of the Month")
        })

        ## trend plot by day of the week -----
        trDOW <- reactive({
            if (!input$trendDOW) return(NULL)
            trendByTime(sentiments(), reviewWkDay, "Day of the Week")
        })


        ## output the frequency plots according to input ----
        output$alltrends <- renderPlot({
            ptlist <- list(trYr(), trMo(), trDOM(), trDOW())
            todelete <- !sapply(ptlist, is.null)
            ptlist <- ptlist[todelete]

            if (length(ptlist) == 0) return(NULL)

            grid.arrange(grobs = ptlist, ncol = 1)
        })

        ## show the data set that was selected -----
        output$selectedData3 <- renderText({
            switch (input$filename,
                    mi = paste("Data set:    ", "Musical Instruments"),
                    op = paste("Data set:    ", "Office Products")
            )
        })
        
        #### Goes with Product Insights tab ------------------------------
        
        ## show the bigrams and trigrams -----
        output$bigram <- renderPlot({
            withProgress(message = "Making Plot", value = 1.0,{
            temp <- df()
          
            d <- data_frame(txt = temp$reviewText)
            d <- removeNumbers(d$txt)
            d <- data_frame(txt = d)
            d <- d[-which(is.na(d)), ] # have to remove NAs for it to work in Shiny
            
            bigrams <- d %>% 
               unnest_tokens(bigram, txt, token = "ngrams", n = 2) %>%
                separate(bigram, c("word1", "word2"), sep = " ") %>%
                filter(!word1 %in% stop_words$word,
                       !word2 %in% stop_words$word) %>%
                count(word1, word2, sort = TRUE) %>%
                unite("bigram", c(word1, word2), sep = " ") %>%
                top_n(15)
            
            ggplot(bigrams, aes(reorder(bigram, n), n, group = 1, fill = bigram)) +
                geom_bar(stat = "identity",
                         show.legend = FALSE) +
                scale_x_discrete("Bigram") +
                scale_y_continuous("Frequency") +
                coord_flip() +
                labs(title = "Top 15 Bigrams")
            
            })
        })
        ## show the trigrams ----
        output$trigram <- renderPlot({
            withProgress(message = "Making Plot", value = 1.0,{
                temp <- df()
                
                d <- data_frame(txt = temp$reviewText)
                d <- removeNumbers(d$txt)
                d <- data_frame(txt = d)
                d <- d[-which(is.na(d)), ] # have to remove NAs for it to work in Shiny
            
                trigrams <- d %>% 
                    unnest_tokens(trigram, txt, token = "ngrams", n = 3) %>%
                    separate(trigram, c("word1", "word2", "word3"), sep = " ") %>%
                    filter(!word1 %in% stop_words$word,
                           !word2 %in% stop_words$word,
                           !word3 %in% stop_words$word) %>%
                    count(word1, word2, word3, sort = TRUE) %>%
                    unite("trigram", c(word1, word2, word3), sep = " ") %>%
                    top_n(15)
                
                ggplot(trigrams, aes(reorder(trigram, n), n, group = 1, fill = trigram)) +
                    geom_bar(stat = "identity",
                             show.legend = FALSE) +
                    scale_x_discrete("Trigram") +
                    scale_y_continuous("Frequency") +
                    coord_flip() +
                    labs(title = "Top 15 Trigrams")    
            })
        })

        ## show the data set that was selected -----
        output$selectedData4 <- renderText({
            switch (input$filename,
                    mi = paste("Data set:    ", "Musical Instruments"),
                    op = paste("Data set:    ", "Office Products")
            )
        })
        
        #### Goes with General Sentiments tab ----------------------------
        
        ## show the negation plots -----
        output$negated <- renderPlot({
            withProgress(message = "Making Plot", value = 1.0,{
                temp <- df()
                
                d <- data_frame(txt = temp$reviewText)
                d <- removeNumbers(d$txt)
                d <- data_frame(txt = d)
                d <- d[-which(is.na(d)), ] # have to remove NAs for it to work in Shiny
                AFINN <- get_sentiments("afinn")
                
                negation_words <- c("not", "no", "never", "without")
                
                negated <- d %>%
                    unnest_tokens(bigram, txt, token = "ngrams", n = 2) %>%
                    separate(bigram, c("word1", "word2"), sep = " ") %>%
                    filter(word1 == negation_words) %>%
                    inner_join(AFINN, by = c(word2 = "word")) %>%
                    count(word1, word2, value, sort = TRUE) %>%
                    ungroup()
                
                negated %>%
                    mutate(contribution = n * value) %>%
                    arrange(desc(abs(contribution))) %>%
                    group_by(word1) %>%
                    top_n(10, abs(contribution)) %>%
                    ggplot(aes(drlib::reorder_within(word2, contribution, word1), contribution, fill = contribution > 0)) +
                    geom_bar(stat = "identity", show.legend = FALSE) +
                    xlab("Words Preceded By Negating Word") +
                    ylab("Sentiment Score x Number of Occurrences") +
                    drlib::scale_x_reordered() +
                    facet_wrap(~ word1, scales = "free") +
                    coord_flip()
            })
        })
        
        ## show bigram network -----
        output$network <- renderPlot({
            withProgress(message = "Making Plot", value = 1.0,{
                temp <- df()
                
                d <- data_frame(txt = temp$reviewText)
                d <- removeNumbers(d$txt)
                d <- data_frame(txt = d)
                d <- d[-which(is.na(d)), ] # have to remove NAs for it to work in Shiny
                bigram_df <- d %>%
                    unnest_tokens(bigram, txt, token = "ngrams", n = 2) %>%
                    separate(bigram, c("word1", "word2"), sep = " ") %>%
                    filter(!word1 %in% stop_words$word,
                           !word2 %in% stop_words$word) %>%
                    count(word1, word2, sort = TRUE) %>%
                    unite("bigram", c(word1, word2), sep = " ") %>%
                    filter(n > 20) %>%
                    separate(bigram, c("word1", "word2"), sep = " ")
                
                bigram_graph <- bigram_df[bigram_df$n >= 70, ] %>%
                    igraph::graph_from_data_frame()
                
                set.seed(555)
                
                arw <- grid::arrow(type = "closed",
                                   length = unit(0.085, "inches"))
                
                ggraph(bigram_graph, layout = "fr") +
                    geom_edge_link(arrow = arw) +
                    geom_node_point(color = "steel blue", size = 2.5) +
                    geom_node_text(aes(label = name), vjust = 1, hjust = 1) +
                    theme_void() +
                    labs(title = "Network of Bigram Clusters with Count > 70")
                
            })
        })

        ## show the data set that was selected -----
        output$selectedData5 <- renderText({
            switch (input$filename,
                    mi = paste("Data set:    ", "Musical Instruments"),
                    op = paste("Data set:    ", "Office Products")
            )
        })


        #### Goes with Topic Insights tab --------------------------------
        
        ## build the word cloud -----
        output$cloud <- renderPlot({
            withProgress(message = "Making Plot", value = 1.0,{
            temp <- df()
            
            corpus <- VCorpus(VectorSource(temp$reviewText))
            
            tdm <- TermDocumentMatrix(corpus,
                                      control = list(removePunctuation = TRUE,
                                                     removeNumbers = TRUE,
                                                     tolower = TRUE,
                                                     stemming = FALSE,
                                                     stopwords = stopwords("SMART"),
                                                     minDocFreq = 1,
                                                     minWordLength = 3)
            )
            
            tdm_reduced <- removeSparseTerms(tdm, 0.99)
            
            m <- as.matrix(tdm_reduced)
            v <- sort(rowSums(m), decreasing = TRUE)
            d <- data.frame(word = names(v),
                            freq = as.numeric(v))
            
            pal <- brewer.pal(9, "Paired")
            pal <- pal[-(1:2)]
            
            wordcloud(d$word, d$freq, scale = c(8, 0.5),
                      min.freq = 5, max.words = 75,
                      random.order = FALSE, rot.per = 0.15,
                      colors = pal, vfont = c("sans serif", "plain")
            )
            })
        })

        ## show the data set that was selected -----
        output$selectedData6 <- renderText({
            switch (input$filename,
                    mi = paste("Data set:    ", "Musical Instruments"),
                    op = paste("Data set:    ", "Office Products")
            )
        })
        
    }
)