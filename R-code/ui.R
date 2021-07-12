#Load Libaries
library(shiny)
library(shinydashboard)
library(shinyWidgets)
######################

# Define the sidebar
sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Overview", tabName = "overview", icon = icon("desktop")),
    menuItem("Equities", tabName = "Equities", icon = icon("chart-line")),
    menuItem("Precious Metals", tabName = "PreciousMetals", icon = icon("chart-line")),
    menuItem("Data", tabName = "data", icon = icon("table")),
    menuItem("General Information", tabName = "info", icon = icon("info-circle"))
  )
)


# Define the body
body <- dashboardBody(

  tabItems(
    
    #Overview
    tabItem(tabName = "overview",
            
            #Description
            h3(tags$b("Impact of Covid-19 on the economy:")),
            p("This App should give you an opportunity to analyse the influence of Covid-19 on the Economy."),
            p("To see the impact on parts of the economy, switch to the Equities or Precious Metals tab.", 
              br(), "Here you should be able to see how companies or precious metals can make profits or losses with increasing numbers of infections/deaths."),

            # Row 1
            fluidRow(
              
              #Column 1
              infoBoxOutput("google_news", width=4), infoBoxOutput("google_news2", width=4), infoBoxOutput("google_news3", width=4)
              ),
            
            #Row 2
            fluidRow(
              #Column 1
              box(title = "Top 10 countries with most deaths:", width = 6, background = "purple",
                  plotlyOutput("top_10_most_deaths")),
              
              #Column 1
              box(title = "Top 10 countries with most cases:", width = 6, background = "purple",
                  plotlyOutput("top_10_most_cases")),
            )
            
    ),
    
    
    #Equities
    tabItem(
      
      tabName = "Equities",
          
      #Description
        h3(tags$b("Impact of Covid-19 on Equities:")),
      
         #Row 1 selectInput Boxes
            fluidRow(
            #Column 1
            box(title = "Country", width = 4, background = "purple",
                selectInput("countriesAndTerritories", "", choices = c(unique(covid$countriesAndTerritories)), selected = "USA")
            ),
            
            
            #Column 2
            box(title = "Y-Axis of Covid-19 Data:", width = 4, background = "purple",
                varSelectInput("cases_or_death", "", data = cases_or_death, selected = "cases")
            ),
            
            #Column 3
            box(title = "Equities", width = 4, background = "purple",
                varSelectInput("select_equities", "", data = select_equities, selected = "Google")
            )
            
            ),

        # Row 2 Covid-19 plot
        fluidRow(
            #Column 1
            box(title = "", width = 12, background = "purple",
               plotlyOutput("covid_visualization"))
           ),

        # Row 3 Equities plot
        fluidRow(
           #Column 1
           box(title = "", width = 12, background = "purple",
               plotlyOutput("Equities_plot"))
           )

    ),
    
    #Metal Data
    tabItem(tabName = "PreciousMetals",
            
            #Description
            h3(tags$b("Impact of Covid-19 on Precious Metals:")),
            
            #Row 1 selectInput Boxes
            fluidRow(
              
              #Column 1 
              box(title = "Country", width = 4, background = "purple",
                  selectInput("countriesAndTerritories2", "", choices = c(unique(covid4$countriesAndTerritories)), selected = "USA")
              )
              
              , 
                
              #Column 2
              box(title = "Y-Axis of Covid-19 Data:", width = 4, background = "purple",
                  varSelectInput("cases_or_death2", "", data = cases_or_death2, selected = "cases")
              ),
  
              #Column 3
              box(title = "Metal type", width = 4, background = "purple",
                    varSelectInput("select_metal_type", "", data = select_metal_type, selected = "Gold")
              )
          ),

         # Row 2 Covid-19 plot
         fluidRow(
            #Column 1
            box(title = "", width = 12, background = "purple",
                plotlyOutput("covid_visualization2"))
               ),  
            
        # Row 3 Metal Data Plot
        fluidRow(
        #Column 1
            box(title = "", width = 12, background = "purple",
              plotlyOutput("metal_data_plot"))
            )
    ),
    
    
    
    #Data-Tables
    tabItem(tabName = "data",
            
            
            #Description
            h3(tags$b("Data tables that were used to create the graphics:")),
            
            
            # Row 1
            fluidRow(
              # Column 1
              box(title = "Covid19 Data", width = 12,
                  DT::dataTableOutput("covid"))
            ),
            
            # Row 2
            fluidRow(
              # Column 1
              box(title = "Precious Metals Data (value in $)", width = 12,
                  DT::dataTableOutput("metal_data"))
            ),
            
            # Row 3
            fluidRow(
              # Column 1
              box(title = "Equities Data (value in $)", width = 12,
                  DT::dataTableOutput("Equities"))
            )
    ),
      
      #Information
      tabItem(tabName = "info",
              
              #Sources
              
              h3(tags$b("General Information:")),
              
              #All Links (they will only work in your browser)
              
              p(tags$b("Google-News Data:"), "(Contains: Top 10 Infections/Deaths || Total Number of Infections || Total Number of Deaths || New Infections[14 days])",
              tags$a(href="https://news.google.com/covid19/map?hl=de&gl=DE&ceid=DE%3Ade", "Click here!")),
              
              p(tags$b("Covid-19 Data:"), "(Contains: Visualization in Equities and Precious Metal tab)",
              tags$a(href="https://www.ecdc.europa.eu/en/publications-data/download-todays-data-geographic-distribution-covid-19-cases-worldwide", "Click here!")),
              
              p(tags$b("Equities Data:"), "(Contains: Visualization in Equities tab)",
              tags$a(href="https://www.rdocumentation.org/packages/quantmod/versions/0.4.17/topics/getSymbols", "Click here!")),
              
              p(tags$b("Precious Metal Data:"), "(Contains: Visualization in Precious Metal tab)",
                tags$a(href="https://www.quandl.com/data/PERTH-Perth-Mint", "Click here!"))
              )
)
)

dashboardPage(
  dashboardHeader(title = "Economy | Covid-19"),
  sidebar,
  body, skin = "purple"
)