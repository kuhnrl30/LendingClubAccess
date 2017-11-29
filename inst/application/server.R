function(input,output, session){

  # load("../../Extraneous/cred.rds")

# Session ----
  session$onSessionEnded(stopApp)
  values <- reactiveValues()

# Transfer funds
  observeEvent(input$deposit, {
    AddFunds(input$withdrawAmount, 
             input$depositCycle, 
             input$dateRangeInput[1], 
             input$dateRangeInput[2])
  })
  
  observeEvent(input$withdraw, {
    # WithdrawFunds(input$transferAmount)
    showNotification("Withdrawl processing", type= "warning")
  })
  
  
# Primary Market ----
  output$primary <- DT::renderDataTable(DT::datatable({
      data<- LendingClub::ListedLoans()$content$loans

      data<- data[data$intRate >= min(input$intRateRange) && data$intRate <= input$intRateRange[2], ]

      if(!("All" %in% input$loanPurposeInput)) {
          data<- data[data$purpose %in% input$loanPurposeInput, ]
      }
      
      data
      }, rownames = FALSE)#,
                  # options = list(
                  #   lengthMenu = list(c(5, 15, -1), c('5', '15', 'All')),
                  #   pageLength = 15)
      )

# Holdings ----
  output$holdings <- DT::renderDataTable(DT::datatable({
    data<- LendingClub::DetailedNotesOwned()$content


    if(input$portfolioNameInput != "All") {
      data<- data[data["portfolioName"]== input$portfolioNameInput,]
    }

    if(input$loanStatusInput != "All") {
      data<- data[data["loanStatus"]== input$loanStatusInput,]
    }

    data
  }, rownames=FALSE))

# Account Summary ----
  observeEvent(input$show, {
    showModal(modalDialog(
      title = "Important message",
      "This is an important message!"))
  })
  
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
  
  output$availablecash<- renderText(paste0("$",values$AccountSummaryData$availableCash))
  output$AcctTotal    <- renderText(paste0("$",values$AccountSummaryData$accountTotal))
  output$AccruedInterest <- renderText(paste0("$",values$AccountSummaryData$accruedInterest))
  output$InterestReceived <- renderText(paste0("$",values$AccountSummaryData$receivedInterest))
  output$AtRisk <- renderText({paste0("$",values$AtRisk)})
  output$AtRiskRatio<- renderText({round(as.numeric(values$AccountSummaryData$receivedInterest)/values$AtRisk,2)})
  
  
  output$portfolioSumm<- renderTable({
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
  
                                  
} # close session