
shinyServer(function(input,output, session){

    #Setup
    session$onSessionEnded(stopApp)

# Account tab ----
    output$oAccountSummary <- DT::renderDataTable({AccountSummary()$content})

    output$oPortfoliosOwned<- DT::renderDataTable({PortfoliosOwned()$content},
                                                  options = list(lengthMenu = c(5, 25, 50),
                                                                 pageLength = 5),
                                                  selection='single')



    output$oDetailedNotesOwned     <- DT::renderDataTable({DetailedNotesOwned()$content},
                                                          options = list(lengthMenu = c(5, 25, 50),
                                                                         pageLength = 5),
                                                          selection='single')

    output$oListedLoans    <- DT::renderDataTable({ListedLoans()$content},
                                                  options = list(lengthMenu = c(5, 25, 50),
                                                                 pageLength = 10),
                                                  selection='single')

    output$oSecondary      <- DT::renderDataTable({FolioListing()},
                                                  options = list(lengthMenu = c(5, 25, 50),
                                                                 pageLength = 10),
                                                  selection='single')


# Notes tab ----
    # dat<- reactive({
    #     if(input$id=="tabNotesOwned"){
    #         # NotesOwned()$content
    #         GUI_NotesOwned()
    #     } else {
    #         NULL}})

    output$oNotesOwned     <- DT::renderDataTable({GUI_NotesOwned()},
                                                  # options = list(lengthMenu = c(5, 25, 50),
                                                                 # pageLength = 10),
                                                  options = list(lengthChange = FALSE),
                                                  selection='single')

    observeEvent(input$oNotesOwned_rows_selected, {
        info= input$oNotesOwned_rows_selected
        if (is.null(info)) return()
        updateTextInput(session, 'txtLoanId', value = GUI_NotesOwned()[info,1])
        })

# Transfers tab ----

    output$oTransfers <- DT::renderDataTable({PendingTransfers()$content},
                                             options = list(lengthMenu = c(5, 25, 50),
                                                            pageLength = 10),
                                             selection='single')


    })

