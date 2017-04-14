AccountSummUI<- function(id, label= "AccountSumm"){
    ns <- NS(id)

    tagList(
        tabsetPanel("AcctActs",
                    tabPanel("Account Summary",
                             tags$br(),
                             DT::dataTableOutput("oAccountSummary")),
                    tabPanel("Portfolios Owned",
                             tags$br(),
                             DT::dataTableOutput("oPortfoliosOwned")),
                    tabPanel("Notes Owned",
                             id="tabNotesOwned",
                             tags$br(),
                             textInput('txtLoanId', 'Loan ID'),
                             actionButton("bSell",

                                          "Sell"),
                             tags$br(),
                             tags$br(),
                             DT::dataTableOutput("oNotesOwned")),
                    tabPanel("Detailed Notes Owned",
                             tags$br(),
                             actionButton("btnSell",

                                          "Sell"),
                             tags$br(),
                             tags$br(),
                             DT::dataTableOutput("oDetailedNotesOwned"))
                    )
            )
    }


# tabsetPanel("AcctActs",
#             tabPanel("Account Summary",
#                      tags$br(),
#                      DT::dataTableOutput("oAccountSummary")),
#             tabPanel("Portfolios Owned",
#                      tags$br(),
#                      DT::dataTableOutput("oPortfoliosOwned")),
#             tabPanel("Notes Owned",
#                      id="tabNotesOwned",
#                      tags$br(),
#                      textInput('txtLoanId', 'Loan ID'),
#                      actionButton("bSell",
#
#                                   "Sell"),
#                      tags$br(),
#                      tags$br(),
#                      DT::dataTableOutput("oNotesOwned")),
#             tabPanel("Detailed Notes Owned",
#                      tags$br(),
#                      actionButton("btnSell",
#
#                                   "Sell"),
#                      tags$br(),
#                      tags$br(),
#                      DT::dataTableOutput("oDetailedNotesOwned"))
# )),
