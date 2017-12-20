shinyUI(
    navbarPage(title= "Lending Club Access",
               theme="journal.css",
               position = "static-top",
               collapsible = T,
               fluid = TRUE,
               tags$head(
                 tags$link(rel = "stylesheet", type = "text/css", href = "table.css")),
               # Dashboard  ----
               tabPanel("Dashboard",
                        # tabsetPanel(
                        #   tabPanel("Dashboard",
                    fluidRow(
                      column(4, wellPanel(
                
                        tags$table(class = "inputs-table",
                            tags$tr(
                                tags$td("Avaible Cash"),
                                tags$td(textOutput("availablecash"))),
                            tags$tr(
                                tags$td("Account Total"),
                                tags$td(textOutput("AcctTotal"))),
                            tags$tr(
                                tags$td("Accrued Interest"),
                                tags$td(textOutput("AccruedInterest"))),
                           tags$tr(
                               tags$td("Interest Recieved"),
                               tags$td(textOutput("InterestReceived"))),
                           tags$tr(
                               tags$td("Principal At Risk"),
                               tags$td(textOutput("AtRisk"))),
                           tags$tr(
                               tags$td("Ratio"),
                               tags$td(textOutput("AtRiskRatio")))))),
  
                      column(8, 
                              tableOutput('portfolioSumm'),
                              tags$i("Excludes notes sold on the secondary market"))),
                    fluidRow(
                      plotlyOutput("summaryPlot") %>% withSpinner(type=4)
                    ),
                    actionButton("acctSummUpdate","Refresh", icon=icon("refresh"))
                    ), # closes the dashboard
              # holdings ----
               tabPanel("Holdings",
                        fluidRow(
                            column(2,
                                 selectInput("portfolioNameInput","Portfolio",PortfolioNames),
                                 selectInput("loanStatusInput","Status",status_opts),
                                 actionButton("refreshNotes", "Refresh", icon=icon("refresh")),
                                 tags$br(),
                                 tags$br(),
                                 actionButton("sellbutton","Sell Notes")),
                            column(10,
                                   DT::dataTableOutput('filteredholdings') %>% 
                                     withSpinner(type=4))),
                        bsModal("sellNotes",
                                trigger = "sellbutton",
                                fluidRow(dataTableOutput('saleorder')),
                                actionButton("submitsale","Sell Notes"))),
               tabPanel("Market",
                  tabsetPanel(
                    # Primary Market ----
                    tabPanel("Primary",
                          fluidRow(
                            column(4,
                                   sliderInput("intRateRange","Interest Rate", min=5, max =30, value= c(10,25))),
                            column(4,
                                   selectInput("loanPurposeInput","Purpose", purpose_opts, selected="All", multiple=T)),
                          column(4,
                                 selectInput("loanGrades","Grade", c("All", LETTERS[1:7]), selected="All", multiple=T))),
                          fluidRow(
                            column(4,
                                   selectInput("loanTermInput","Loan Term", c("All","36 mo", "60 mo"), multiple=T)),
                            column(4,
                                   sliderInput("dtiInput","Debt to Income",min=0, max=40, value =c(15,30)))),
                          fluidRow(
                            DT::dataTableOutput('primary'))
                             ), # closes primary
                    # Secondary Market ----
                    tabPanel("Secondary"))),
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
                       )))    
))