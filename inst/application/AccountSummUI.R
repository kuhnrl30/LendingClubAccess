AccountSummUI<- function(id, label= "AccountSumm"){
    ns <- NS(id)

    tagList(
        tabsetPanel("AcctActs",
                    tabPanel("Account Summary",
                             DT::dataTableOutput("oAccountSummary")),
                    tabPanel("Portfolios Owned",
                             DT::dataTableOutput("oPortfoliosOwned")),
                    tabPanel("Notes Owned",
                             id="tabNotesOwned",
                             textInput('txtLoanId', 'Loan ID'),
                             actionButton("bSell", "Sell"),
                             DT::dataTableOutput("oNotesOwned")),
                    tabPanel("Detailed Notes Owned",
                             actionButton("btnSell", "Sell"),
                             DT::dataTableOutput("oDetailedNotesOwned"))
                    )
            )
    }
