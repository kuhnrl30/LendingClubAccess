function(input,output, session){

  # load("../../Extraneous/cred.rds")

# Session ----
  session$onSessionEnded(stopApp)

# Primary Market ----
  output$primary <- DT::renderDataTable(DT::datatable({
      data<- LendingClub::ListedLoans()$content$loans

      data<- data[data$intRate >= input$intRateRange[1] && data$intRate <= input$intRateRange[2], ]

      if(!("All" %in% input$loanPurposeInput)) {
          data<- data[data$purpose %in% input$loanPurposeInput, ]
      }
      data
      }, rownames = FALSE),
                  options = list(
                    lengthMenu = list(c(5, 15, -1), c('5', '15', 'All')),
                    pageLength = 15))

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

  AccountSummaryData<- reactive({
      data<- LendingClub::AccountSummary()$content
      acctsumm <- as.data.frame(t(data[,2]), stringsAsFactors = F)
      colnames(acctsumm)<- t(data[,1])
      acctsumm})

      output$availablecash<- renderText(paste0("$",AccountSummaryData()$availableCash))
      output$AcctTotal    <- renderText(paste0("$",AccountSummaryData()$accountTotal))
      output$AccruedInterest <- renderText(paste0("$",AccountSummaryData()$accruedInterest))


}
