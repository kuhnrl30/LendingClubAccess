

shinyUI(
    navbarPage(title= "Lending Club Access",
               theme="journal.css",
               position = "static-top",
               collapsible = T,
               tabPanel("Account Summary",
                        tabsetPanel(
                          tabPanel("Summary",
                                   DT::dataTableOutput('acctSummary')),
                          tabPanel("Transfer Funds"))),
               tabPanel("Holdings",
                        sidebarLayout(
                          sidebarPanel(
                            selectInput("portfolioNameInput","Portfolio", PortfolioNames),
                            selectInput("loanStatusInput","Status", status_opts)),
                          mainPanel("Holdings",
                                    DT::dataTableOutput('holdings')))),
               tabPanel("Market",
                        tabsetPanel(
                          tabPanel("Primary",
                                   DT::dataTableOutput('primary')),
                          tabPanel("Secondary")))
               ))
