AccountSummUI<- function(id, label= "AccountSumm"){
    ns <- NS(id)

    tagList(
        tabsetPanel("AcctActs",
                    tabPanel("Account Summary",
                             # DT::dataTableOutput("oAccountSummary")
                             cat("Account Summary")),
                    tabPanel("Portfolios Owned",
                             cat("Portfolios Owned")),
                    tabPanel("Notes Owned",
                             id="tabNotesOwned",
                             textInput('txtLoanId', 'Loan ID'),
                             actionButton("bSell", "Sell"),
                             cat("Notes Owned")),
                    tabPanel("Detailed Notes Owned",
                             actionButton("btnSell", "Sell"),
                             cat("Detailed Notes Owned"))
                    )
            )
    }
