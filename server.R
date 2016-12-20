library(shiny)
library(ggplot2)
library(plyr)
  #load data
  resume <- read.csv("resume1611.csv", stringsAsFactors = F) 
  colnames(resume) <-c("機台編號","happenTime","timing","condition","conditionG","生產狀態","工號","累積生產數","生產數","巡機員","error")

  
  shinyServer(function(input, output) {
    aftc <- reactive({less<-subset(resume, timing < input$timing & condition =="異常" & conditionG =="異常")
    aftc<-count(less$error)
    aftc$rank <- NA
    order.freq <- order(aftc$freq, aftc$x, decreasing = T)
    aftc$rank[order.freq]<- 1:nrow(aftc)
    aftc <- as.data.frame(aftc)
    })
    
    output$bar<-renderPlot({
      ggplot(aftc(), aes(x=x, y=freq))+geom_bar(stat="identity", data = subset(aftc(), rank < input$num))
        
    })
   
})
  