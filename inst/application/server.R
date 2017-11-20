function(input,output, session){

  # load("../../Extraneous/cred.rds")

  #Setup
  session$onSessionEnded(stopApp)


  output$primary <- DT::renderDataTable(DT::datatable({
      data<- LendingClub::ListedLoans()$content$loans

      data<- data[between(data$intRate, input$intRateRange[1], input$intRateRange[2]), ]

      if(!("All" %in% input$loanPurposeInput)) {
          data<- data[data$purpose %in% input$loanPurposeInput, ]
      }
      data
      }),
                  options = list(
                    lengthMenu = list(c(5, 15, -1), c('5', '15', 'All')),
                    pageLength = 15),
                  rownames = FALSE)


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

  output$acctSummary<- DT::renderDataTable(
    DT::datatable(LendingClub::AccountSummary()$content,
                  options= list(
                    paging=F,
                    searching=F), rownames = FALSE))

}
