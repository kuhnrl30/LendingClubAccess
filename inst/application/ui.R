

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
                        fluidRow(
                            column(2,
                                 selectInput("portfolioNameInput","Portfolio",PortfolioNames),
                                 selectInput("loanStatusInput","Status",status_opts)),
                            column(10,
                                   DT::dataTableOutput('holdings')))),
               tabPanel("Market",
                        tabsetPanel(
                          tabPanel("Primary",
                                   fluidRow(
                                       column(2,
                                              sliderInput("intRateRange","Interest Rate",
                                                          min=5, max=30,
                                                          value=c(10,25)),
                                              selectInput("loanPurposeInput","Purpose",
                                                          purpose_opts,
                                                          selected="All",
                                                          multiple=T)),
                                       column(10,
                                              DT::dataTableOutput('primary')))),
                          tabPanel("Secondary")))
               ))
