function(input,output, session){

  load("../../Extraneous/cred.rds")
  
  #Setup
  session$onSessionEnded(stopApp)

  
  output$primary <- DT::renderDataTable(
    DT::datatable(LendingClub::ListedLoans()$content$loans,
                  options = list(
                    lengthMenu = list(c(5, 15, -1), c('5', '15', 'All')),
                    pageLength = 15)))

  
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
                    searching=F))) 
    
}