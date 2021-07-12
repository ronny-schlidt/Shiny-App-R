# Load Libaries
library(shiny)
library(shinydashboard)
library(plotly)
library(tidyverse)
library(DT)
library(ggthemes)
library(shinydashboard)
library(scales)
################


shinyServer(function(input, output) {
  
  # Overview
  
  # Top 10 Countries with most Cases
  output$top_10_most_cases <- renderPlotly({
    total_cases_plot <- ggplot(data = total_cases, mapping = aes(x = Cases, y = Country)) +
      geom_bar(aes(text = paste0("Cases: ", Cases)) , stat = "identity", color = "black", fill = "white") +
      scale_x_continuous(labels = number_format(big.mark = ".", decimal.mark =",")) +
      theme(
        panel.background = element_rect(fill = "slateblue4", colour = "white", size = 0.5, linetype = "solid"),
        panel.grid.major = element_line(size = 0.5, linetype = 'solid', colour = "gray89"),
        #panel.grid.major.y = element_blank(),
        legend.position = "none",
        plot.background = element_rect(fill = "slateblue4"),
        plot.caption = element_text(color = "white", hjust = 0),
        plot.title = element_text(face = "bold"),
        axis.title = element_text(face = "bold", color = "white"),
        axis.line.x = element_line(size = 0.5),
        axis.title.y = element_text(colour = "white"),
        axis.text = element_text(colour = "white")) +
        labs(x = "", y = "")
    
    top_10_most_cases <- ggplotly(total_cases_plot, tooltip = "text") %>% layout(plot_bgcolor = "rgba(0,0,0,0)", paper_bgcolor = "rgba(0,0,0,0)")
  })
  
  # Top 10 Countries with most Deaths
  output$top_10_most_deaths <- renderPlotly({
    total_cases_plot <- ggplot(data = total_death, mapping = aes(x = Deaths, y = Country)) +
      geom_bar(aes(text = paste0("Deaths: ", Deaths)) , stat = "identity", color = "black", fill = "white") +
      scale_x_continuous(labels = number_format(big.mark = ".", decimal.mark = ",")) +
      theme(
        panel.background = element_rect(fill = "slateblue4", colour = "white", size = 0.5, linetype = "solid"),
        panel.grid.major = element_line(size = 0.5, linetype = 'solid', colour = "gray89"),
        legend.position = "none",
        plot.background = element_rect(fill = "slateblue4"),
        plot.caption = element_text(color = "white", hjust = 0),
        plot.title = element_text(face = "bold"),
        axis.title = element_text(face = "bold", color = "white"),
        axis.line.x = element_line(size = 0.5),
        axis.title.y = element_text(colour = "white"),
        axis.text = element_text(colour = "white")) +
        labs(x = "", y = "")
    
    top_10_most_deaths <- ggplotly(total_cases_plot, tooltip = "text") %>% layout(plot_bgcolor = "rgba(0,0,0,0)", paper_bgcolor = "rgba(0,0,0,0)")
  })
  
  
  # Total infections
  output$google_news <- renderInfoBox({
    infoBox(title = "Total Infections", width = 4, value = Infections, fill = T, color = "purple")
  })
  
  # Total deaths
  output$google_news2 <- renderInfoBox({
    infoBox(title = "Total deaths", width = 4, value = Deaths, fill = T, color = "purple")
  })
  
  # New infections(14 days)
  output$google_news3 <- renderInfoBox({
    infoBox(title = "New infections (14 days)", width = 4, value = new_infections_14_days, fill = T, color = "purple")
  })
  
  
  # Covid Plot for Equities
  output$covid_visualization <- renderPlotly({
  covid <- covid3 %>% group_by(countriesAndTerritories) %>%
      filter(countriesAndTerritories == input$countriesAndTerritories)
  covid$date <- as.Date(covid$date, format = "%Y-%m-%d")
    plot <-
      ggplot(data = covid, mapping = aes(x = date, y = !!input$cases_or_death)) +
      geom_line(color = "white", size = 0.6) +
      theme(
        panel.background = element_rect(fill = "slateblue4", colour = "white", size = 0.5, linetype = "solid"),
        panel.grid.major = element_line(size = 0.5, linetype = 'solid', colour = "gray89"),
        legend.position = "none",
        plot.background = element_rect(fill = "slateblue4"),
        plot.caption = element_text(color = "white", hjust = 0),
        plot.title = element_text(face = "bold", colour = "white", hjust=0.5),
        axis.title = element_text(face = "bold", color = "white"),
        axis.line.x = element_line(size = 0.5),
        axis.title.y = element_text(colour = "white"),
        axis.text = element_text(colour = "white")) +
        labs(x = "Date", y = "")+
        ggtitle(paste(input$cases_or_death, "of Covid-19 Data"))

    covid_visualization <- ggplotly(plot) %>% layout(plot_bgcolor = "rgba(0,0,0,0)", paper_bgcolor = "rgba(0,0,0,0)")
  })
  
  # Covid Plot for Metal Data
  output$covid_visualization2 <- renderPlotly({
    covid4 <- covid3
    covid5 <- covid4 %>% group_by(countriesAndTerritories) %>%
      filter(countriesAndTerritories == input$countriesAndTerritories2)
    
    covid5$date <- as.Date(covid5$date, format = "%Y-%m-%d")
    
    plot6 <-
      ggplot(data = covid5, mapping = aes(x = date, y = !!input$cases_or_death2)) +
      geom_line(color = "white", size = 0.6) +
      theme(panel.background = element_rect(fill = "slateblue4", colour = "white", size = 0.5, linetype = "solid"),
        panel.grid.major = element_line(size = 0.5,linetype = 'solid', colour = "gray89"),
        legend.position = "none",
        plot.background = element_rect(fill = "slateblue4"),
        plot.caption = element_text(color = "white", hjust = 0),
        plot.title = element_text(face = "bold", colour = "white", hjust=0.5),
        axis.title = element_text(face = "bold", color = "white"),
        axis.line.x = element_line(size = 0.5),
        axis.title.y = element_text(colour = "white"),
        axis.text = element_text(colour = "white")) +
        labs(x = "Date", y = "")+
      ggtitle(paste(input$cases_or_death2, "of Covid-19 Data"))
      
    
    covid_visualization2 <- ggplotly(plot6) %>% layout(plot_bgcolor = "rgba(0,0,0,0)", paper_bgcolor = "rgba(0,0,0,0)")
  })
  
  # Equity Plot
  output$Equities_plot <- renderPlotly({
    
    plot2 <- ggplot(data = Equities, mapping = aes(x = date, y = !!input$select_equities)) +
      geom_line(color = "white", size = 0.6) +
      scale_y_continuous(labels = dollar) +
      theme(
        #plot.title = element_text(colour = "white", hjust = 0.5),
        panel.background = element_rect(fill = "slateblue4", colour = "black", size = 0.5, linetype = "solid"),
        panel.grid.major = element_line(size = 0.5, linetype = 'solid', colour = "gray89"),
        legend.position = "none",
        plot.background = element_rect(fill = "slateblue4"),
        plot.caption = element_text(color = "white", hjust = 0),
        plot.title = element_text(face = "bold", colour="white", hjust = 0.5),
        axis.title = element_text(face = "bold", color = "white"),
        axis.line.x = element_line(size = 0.5),
        axis.text = element_text(colour = "white")) +
        labs(x = "Date", y = "")+
        ggtitle(input$select_equities)
        
    
  
    Equities_plot <-ggplotly(plot2) %>% layout(plot_bgcolor = "rgba(0,0,0,0)", paper_bgcolor = "rgba(0,0,0,0)")
  })
  
  
  # Precious Metal Data Plot
  output$metal_data_plot <- renderPlotly({
    
    plot4 <-ggplot(data = metal_data, mapping = aes(x = date, y = !!input$select_metal_type)) +
      geom_line(color = "white", size = 0.7) +
      scale_y_continuous(labels = dollar) +
      theme(
        panel.background = element_rect(fill = "slateblue4", colour = "black", size = 0.5, linetype = "solid"),
        panel.grid.major = element_line(size = 0.5, linetype = 'solid', colour = "gray89"),
        legend.position = "none",
        plot.background = element_rect(fill = "slateblue4"),
        plot.caption = element_text(color = "white", hjust = 0),
        plot.title = element_text(face = "bold", colour = "white", hjust=0.5),
        axis.title = element_text(face = "bold", color = "white"),
        axis.line.x = element_line(size = 0.5),
        axis.text = element_text(colour = "white")) +
        labs(x = "Date", y = "")+
        ggtitle(input$select_metal_type)
    
    metal_data_plot <- ggplotly(plot4) %>% layout(plot_bgcolor = "rgba(0,0,0,0)", paper_bgcolor = "rgba(0,0,0,0)")
    
  })
  
  # Datatables
  
  # Covid-19 Data
  output$covid <- DT::renderDataTable({
    DT::datatable(covid, filter = 'top')
    
  })
  
  # Precious Metal Data
  output$metal_data <- DT::renderDataTable({
    DT::datatable(metal_data, filter = 'top')
    
  })
  
  # Equities Data
  output$Equities <- DT::renderDataTable({
    DT::datatable(Equities, filter = 'top')
    
  })
  
  
})