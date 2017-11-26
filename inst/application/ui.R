shinyUI(
    navbarPage(title= "Lending Club Access",
               theme="journal.css",
               position = "static-top",
               collapsible = T,
               tabPanel("Account Summary",
                        tabsetPanel(
                          tabPanel("Dashboard",
                            wellPanel(class="col-md-2",
                                tags$table(class = "inputs-table",
                                    tags$tr(
                                        tags$td("Avaible Cash"),
                                        tags$td(textOutput("availablecash"))),
                                    tags$tr(
                                        tags$td("Account Total"),
                                        tags$td(textOutput("AcctTotal"))),
                                    tags$tr(
                                        tags$td("Accrued Interest"),
                                        tags$td(textOutput("AccruedInterest"))))),
                             wellPanel(class="col-md-2",
                                       tags$table(class= "inputs-table",
                                           tags$tr(
                                               tags$td("Interest Recieved"),
                                               tags$td(textOutput("InterestReceived"))),
                                           tags$tr(
                                               tags$td("Principal At Risk"),
                                               tags$td(textOutput("AtRisk"))),
                                           tags$tr(
                                               tags$td("Ratio"),
                                               tags$td(textOutput("AtRiskRatio"))))),
                            wellPanel(class="col-md-10",
                                      tableOutput('portfolioSumm'))
                            ), # closes the dashboard
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
                          tabPanel("Secondary"))),
               tags$head(
                   tags$link(rel = "stylesheet", type = "text/css", href = "table.css")))
    )
