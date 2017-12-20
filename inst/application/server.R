function(input,output, session){

  # load("../../Extraneous/cred.rds")

# Session ----
  session$onSessionEnded(stopApp)
  values <- reactiveValues()

# Transfer funds ----
  observeEvent(input$deposit, {
    AddFunds(input$withdrawAmount, 
             input$depositCycle, 
             input$dateRangeInput[1], 
             input$dateRangeInput[2])
  })
  
  observeEvent(input$withdraw, {
    # WithdrawFunds(input$transferAmount)
    showModal(modalDialog(
      title = "Withdrawl submitted",
      "Withdrawl processing"))
  })
  
  
# Primary Market ----
  output$primary <- DT::renderDataTable(DT::datatable({
      data<- LendingClub::ListedLoans()$content$loans

      data<- data[data$intRate >= min(input$intRateRange) && data$intRate <= input$intRateRange[2], ]

      if(!("All" %in% input$loanPurposeInput)) {
          data<- data[data$purpose %in% input$loanPurposeInput, ]
      }
      
      data %>%
        select(-(acceptD:reviewStatusD))
      }, rownames = FALSE)
      )

# Holdings ----

  filteredholdings<- reactive({
    
    input$refreshNotes
    
    data<- LendingClub::DetailedNotesOwned()$content
      if(input$portfolioNameInput != "All") {
        data<- data[data["portfolioName"]== input$portfolioNameInput,]
        }

      if(input$loanStatusInput != "All") {
        data<- data[data["loanStatus"]== input$loanStatusInput,]
        }
    data %>%
      mutate(CFRatio= round((as.numeric(paymentsReceived) - as.numeric(noteAmount)) / as.numeric(noteAmount),2)) %>%
      select(c(loanId, purpose, grade, noteAmount, CFRatio, interestRate, loanStatus, creditTrend, portfolioName))

    
    })
  
  output$filteredholdings<- DT::renderDataTable(
    DT::datatable(filteredholdings(),rownames = FALSE)
    )

# Account Summary ----
    values$AccountSummaryData<- {
      
      data<- LendingClub::AccountSummary()$content
      acctsumm <- as.data.frame(t(data[,2]), stringsAsFactors = F)
      colnames(acctsumm)<- t(data[,1])
      acctsumm}
    
    values$holdings<- LendingClub::DetailedNotesOwned()$content
    
    values$AtRisk<- {
      dat<- LendingClub::DetailedNotesOwned()$content
      dat<-dat[dat$loanStatus %in% at_risk_status,]    
      sum(as.numeric(dat$noteAmount)- as.numeric(dat$principalReceived))
      }

  
    output$availablecash<- renderText({
      input$acctSummUpdate
      paste0("$",values$AccountSummaryData$availableCash)})
    
    output$AcctTotal    <- renderText({
      input$acctSummUpdate
      paste0("$",values$AccountSummaryData$accountTotal)})
    
    output$AccruedInterest <- renderText({
      input$acctSummUpdate
      paste0("$",values$AccountSummaryData$accruedInterest)})
    
    output$InterestReceived <- renderText({
      input$acctSummUpdate
      paste0("$",values$AccountSummaryData$receivedInterest)})
    
    output$AtRisk <- renderText({
      input$acctSummUpdate
      paste0("$",values$AtRisk)})
    
    output$AtRiskRatio<- renderText({
      input$acctSummUpdate
      round(as.numeric(values$AccountSummaryData$receivedInterest)/values$AtRisk,3)})
    
    
    output$portfolioSumm<- renderTable({
      
      input$acctSummUpdate
      
      values$holdings %>% 
        # dat %>%
        mutate(PurchaseDiscount= as.numeric(principalReceived)+as.numeric(principalPending)-as.numeric(noteAmount),
               chargeOff= ifelse(currentPaymentStatus=="ChargedOff", principalPending,0),
               principalPending= ifelse(currentPaymentStatus=="ChargedOff",0, principalPending),
               WgtIntRate= as.numeric(interestRate) * as.numeric(principalPending)) %>%
        group_by(portfolioName) %>%
        summarize("Amount Invested"= sum(as.numeric(noteAmount)),
                  Discount= sum(PurchaseDiscount),
                  "Charged Off" = -sum(as.numeric(chargeOff)),
                  "Principal Received" = -sum(as.numeric(principalReceived)),
                  Outstanding = sum(as.numeric(principalPending)),
                  "Interest Received"= sum(as.numeric(interestReceived)),
                  "Payments Received" = sum(as.numeric(paymentsReceived)),
                  sumWgtIntRate = sum(WgtIntRate)) %>%
        mutate("Wgt Int Rate"= round(sumWgtIntRate/ Outstanding,2)) %>%
        select(-sumWgtIntRate) %>%
        rename(Portfolio= portfolioName,
               "Net Outstanding"= Outstanding) %>%
        gather("Metric","val", -Portfolio) %>%
        # str()
        mutate(Metric= factor(Metric, levels=c("Amount Invested","Discount","Charged Off","Principal Received","Net Outstanding","Interest Received","Payments Received","Wgt Int Rate"))) %>%
        spread(Portfolio,val) %>%
        mutate(Total = rowSums(select_(.,"-Metric"))) %>%
        mutate(Total= ifelse(Metric=="Wgt Interest Rate",NA,Total))
    })
  
                                  
    
# Summary Plot ----
    output$summaryPlot<- renderPlotly({
      
      input$acctSummUpdate
      
      dat<- values$holdings
      
      dat<-dat %>%
        mutate(CFRatio= round((as.numeric(paymentsReceived) - as.numeric(noteAmount)) /as.numeric(noteAmount)*100,2),
               orderDate= as.Date(orderDate))
      
      dat$simpleStatus <- case_when(dat$loanStatus == "Charged Off" ~ "Complete",
                                      dat$loanStatus == "Current" ~"Performing",
                                      dat$loanStatus == "Fully Paid" ~ "Complete",
                                      dat$loanStatus == "In Grace Period" ~ "Performing",
                                      dat$loanStatus == "In Review" ~ "Performing",
                                      dat$loanStatus == "Issued" ~ "Performing",
                                      dat$loanStatus == "Late (16-30 days)" ~ "Late",
                                      dat$loanStatus == "Late (31-120 days)" ~ "Late")
      
      ThreeYear<- as.Date(Sys.time())-(365*3)
      FiveYear<- as.Date(Sys.time()-(365*5))
      
      g<- ggplot(dat)
      g<- g + aes(x= orderDate, y= CFRatio, group= portfolioName, color= simpleStatus)
      g<- g + geom_point()
      g<- g + scale_x_date(limits= c(ThreeYear-150, as.Date(Sys.time())+50))
      g<- g + facet_grid(~portfolioName)
      g<- g + theme_LC()
      g<- g + labs(x= "Order Date",
                   y= "Payback Ratio")
      g<- g + geom_hline(yintercept =0, linetype="dashed")
      g<- g + theme(legend.position="none",
                    panel.border  = element_rect(colour = "black", fill=NA))
      
      ggplotly(g)
      
    })
    
# Sell notes\
    output$saleorder<- renderDataTable({
      filteredholdings()[input$filteredholdings_rows_selected,1:5]
    })
    # observeEvent(input$sellbutton, {
    #   showModal(modalDialog(
    #     title="Selling Notes",
    #     "test"))
    #   
    # })
    
} # close session