shinyUI(
    navbarPage("Lending Club Access",
               theme="journal.css",
               tabPanel("Account Actions", AccountSummUI("AcctSumm")),
               tabPanel("Market",MarketUI()),
               tabPanel("Transfers", TransferUI()),
               tabPanel("Setup", SetupUI())

    ))
