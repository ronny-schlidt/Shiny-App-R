# Load Libraries
library(Quandl)
library(quantmod)
library(plotly)
library(ggplot2)
library(tidyverse)
library(data.table)
library(dplyr)
library(lubridate)
library(rvest)
library(scales)
#####################

### Covid19 Data:

# Load and transform Data from csv file
covid2 <- read.csv("https://opendata.ecdc.europa.eu/covid19/casedistribution/csv", na.strings = "", fileEncoding = "UTF-8-BOM")
covid <- covid2
covid$date <- strptime(as.character(covid$date), "%d/%m/%Y")
covid$date <- format(covid$date, "%Y-%m-%d")
covid <- covid %>% filter(date > "2020-01-03")
names(covid)[12] <- "fourteendaysaverage"
covid$dateRep <- NULL

# Rename countries
covid$countriesAndTerritories <- as.character(covid$countriesAndTerritories)
covid$countriesAndTerritories[covid$countriesAndTerritories == "United_States_of_America"] <- "USA"
covid$countriesAndTerritories[covid$countriesAndTerritories == "United_Kingdom"] <- "UK"
covid$countriesAndTerritories[covid$countriesAndTerritories == "South_Korea"] <- "S Korea"


#Select Columns
covid <- covid %>% select("date", "deaths", "cases", "countriesAndTerritories", "fourteendaysaverage")

# Duplicate for second plot
covid3 <- covid
covid4 <- covid3


# Selection for Y-Axis
cases_or_death <- covid3 %>% select(cases, deaths)
cases_or_death2 <- cases_or_death


#### Covid-19 Total Cases from google news with Web-Scraping

#Load and transform data
google_news <-html("https://news.google.com/covid19/map?hl=de&gl=DE&ceid=DE%3Ade")

# Total Infections
Infections <- google_news %>% html_nodes(".qs41qe .UvMayb") %>% html_text()

# Total Death
Deaths <- google_news %>% html_nodes(".ckqIZ .UvMayb") %>% html_text()

# New infections (14 days)
new_infections_14_days <- google_news %>% html_nodes("strong") %>% html_text()


###Top 10 Countries with most cases

# Create total cases and total death column of top 10 countries

# Top 10 Countries with most cases
total_cases <- covid3 %>% select(date, cases, countriesAndTerritories) %>%
                          group_by(countriesAndTerritories) %>%
                          summarize(cases_sum = sum(cases))

total_cases <- tail(total_cases %>% arrange(total_cases$cases_sum), 10)
total_cases$countriesAndTerritories <- factor(total_cases$countriesAndTerritories, levels = total_cases$countriesAndTerritories)
total_cases <- total_cases %>% rename(Cases = cases_sum, Country = countriesAndTerritories)


# Top 10 Countries with most deaths
total_death <- covid3 %>% select(date, deaths, countriesAndTerritories) %>%
                          group_by(countriesAndTerritories) %>%
                          summarize(deaths_sum = sum(deaths))

total_death <- tail(total_death %>% arrange(total_death$deaths_sum), 10)
total_death$countriesAndTerritories <- factor(total_death$countriesAndTerritories, levels = total_death$countriesAndTerritories)
total_death <- total_death %>% rename(Deaths = deaths_sum, Country = countriesAndTerritories)

####################################

### Equities Data:

startdate <- "2020-01-03"
names <- c("date","Amazon","Google","Biontech","Pfizer","Tesla","Apple","Microsoft","Facebook")
tickers <- c("AMZN", "GOOGL", "BNTX", "PFE", "TSLA", "AAPL", "MSFT", "FB")
Equities <- NULL

# Load Data
for(ticker in tickers) Equities <- cbind(Equities, getSymbols(ticker, from = startdate, auto.assign = F)[, 6])
Equities.df <- as.data.frame(Equities)
Equities <- Equities.df

# Transform and rename
setDT(Equities, keep.rownames = TRUE)[]
colnames(Equities) <- names
rm(Equities.df)
Equities$date <- as.Date(Equities$date, format = "%Y-%m-%d")

# Delete date Column -> choose only between equities
select_equities <- Equities[, -1]


####################################

#Metal prices in London

# Load Data
metal_data <- Quandl("PERTH/LONMETALS")
names2 <- c("date","Gold1","Gold","Silver","Plat1","Platinum","Palladium1","Palladium","6-Month-Gold")

# Rename
colnames(metal_data) <- names2
metal_data <- metal_data %>% select(date, Gold, Silver, Platinum, Palladium)

# Filter
metal_data <- metal_data %>% filter(date > "2020-01-03")

#Delete date Column -> choose only Metal type
select_metal_type <- metal_data %>% select(Gold, Silver, Platinum, Palladium)
