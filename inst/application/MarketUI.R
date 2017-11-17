MarketUI<- function(id, label="Market"){
    ns <- NS(id)

    tagList(
        tabsetPanel("NotesMenu",
                    tabPanel("Primary Market",
                             tags$br(),
                             actionButton("btnBuy",
                                          "Buy Note"),
                             tags$br(),
                             tags$br(),
                             DT::dataTableOutput("oListedLoans")),
                    tabPanel("Secondary Market",
                             DT::dataTableOutput("oSecondary"))
                    )
        )
    }

