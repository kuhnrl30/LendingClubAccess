shinyUI(
    navbarPage("Lending Club Access",
               theme="journal.css",
               tabPanel("Account Actions", AccountSummUI()),
               tabPanel("Market",MarketUI()),
               tabPanel("Transfers", TransferUI()),
               tabPanel("Setup", SetupUI())

    ))
