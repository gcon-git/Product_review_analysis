# Description

This file serves to provide screenshots of what the app looks like when it is run via R/RStudio.

It's a fairly basic "app" with limited user intereaction features. Since this was the first Shiny app that I've developed, I tried to include some customization while still keeping focused on the analytics done behind the scenes. 

Principle navigation on the app is simply clicking on the appropriate tab at the top of the web page. On each page there are radio buttons or check-boxes to let a user select information that he/she is interested in. 

The following are screenshots of each tab/page. If you choose to clone the repository, download the data and run the app on your own machine then your results should look similar to the images below.

***

# Screenshots

## 1. Data tab - the opening page

Allows a user to select the data set of interest and see some quick information about the data set.

![](https://github.com/gcon-git/Product_review_analysis/blob/master/img_files/1-Opening_page.png?raw=true)

## 2. Frequencies tab

Plots of the number of reviews. Users can select the time period of interest (i.e., by year, by month, by day of the month, or by day of the week). This page does not feature the ability to focus on specific years, months, etc.

![](https://github.com/gcon-git/Product_review_analysis/blob/master/img_files/2-Frequencies.png?raw=true)

## 3. Distributions tab

Shows plots of the rating profiles (i.e., 1, 2, 3, etc) based on the user's time period of interest (i.e., by year, by month, by day of the month, or by day of the week). This page does not feature the ability to focus on specific years, months, etc.

![](https://github.com/gcon-git/Product_review_analysis/blob/master/img_files/3-Distributions.png?raw=true)

## 4. Trends tab

Plots the trend changes of review sentiments based on their standard deviations. Users can select the time period of interest (i.e., by year, by month, by day of the month, or by day of the week). This page does not feature the ability to focus on specific years, months, etc.

![](https://github.com/gcon-git/Product_review_analysis/blob/master/img_files/4-Trends.png?raw=true)

## 5. Product Insights tab

Shows the top 15 bigram and trigrams obtained from the user review data. The intent of this page was to gain insight on popular products, brands, and/or features based on product reviews.

![](https://github.com/gcon-git/Product_review_analysis/blob/master/img_files/5-Insights.png?raw=true)

## 6. General Sentiments tab

This page provides insight on overall sentiment of the reviews. It also includes a bigram network plot to gain insight on bigram relationships to better understand the context in which the words were used.

![](https://github.com/gcon-git/Product_review_analysis/blob/master/img_files/6-GenSentiments.png?raw=true)

## 7. Topic Insights tab

Provides a word cloud of the most frequent terms used across all reviews.

![](https://github.com/gcon-git/Product_review_analysis/blob/master/img_files/7-WordCloud.png?raw=true)