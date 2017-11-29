shinyUI(
    navbarPage(title= "Lending Club Access",
               theme="journal.css",
               position = "static-top",
               collapsible = T,
               
               # Account Summary ----
               tabPanel("Account Summary",
                        tabsetPanel(
                          tabPanel("Dashboard",
                            fluidRow(
                              column(5, wellPanel(
                                tags$table(class = "inputs-table",
                                    tags$tr(
                                        tags$td("Avaible Cash"),
                                        tags$td(textOutput("availablecash"))),
                                    tags$tr(
                                        tags$td("Account Total"),
                                        tags$td(textOutput("AcctTotal"))),
                                    tags$tr(
                                        tags$td("Accrued Interest"),
                                        tags$td(textOutput("AccruedInterest")))))),
                             column(5, wellPanel(
                                       tags$table(class= "inputs-table",
                                           tags$tr(
                                               tags$td("Interest Recieved"),
                                               tags$td(textOutput("InterestReceived"))),
                                           tags$tr(
                                               tags$td("Principal At Risk"),
                                               tags$td(textOutput("AtRisk"))),
                                           tags$tr(
                                               tags$td("Ratio"),
                                               tags$td(textOutput("AtRiskRatio"))))))),
                            column(10, wellPanel(class="col-md-10",
                                      tableOutput('portfolioSumm'),
                                      tags$i("Excludes notes sold on the secondary market")))
                            ), # closes the dashboard
                          tabPanel("Transfer Funds",
                            fluidRow(
                              column(4,
                                     numericInput("depositAmount", label=h3("Amount to Deposit"), 0),
                                     selectInput("depositCycle", label=h3("Cycle"), deposit_opts),
                                     dateRangeInput("dates", label = h3("Date range")),
                                     actionButton("deposit", "Deposit")),
                              column(4,
                                   numericInput("withdrawAmount", h3("Amount to Withdraw"), 0),
                                   actionButton("withdraw", "Withdraw")
                                   ))) # Closes Trasfers
                          )),
               # Dashboard ----
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
                                              DT::dataTableOutput('primary')))
                                
                                   ), # closes primary
                          tabPanel("Secondary"))),
               tags$head(
                   tags$link(rel = "stylesheet", type = "text/css", href = "table.css")))
    )
