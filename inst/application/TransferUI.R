TransferUI<- function(id, label="Transfers"){
    ns <- NS(id)

    tagList(
        tabPanel("Transfers",
                 tabsetPanel("TransferMenu",
                             tabPanel("Scheduled Transfers",
                                      id="tabScheduledTransfers",
                                      tags$br(),
                                      actionButton("btnCancel",
                                                   "Cancel Transfer"),
                                      tags$br(),
                                      tags$br(),
                                      DT::dataTableOutput("oTransfers")),
                             tabPanel("Add Funds",
                                      id="tabAddFunds",
                                      textInput("txtAmount", "Amount"),
                                      selectInput("txtFreq", "Frequency",
                                                  c("Now"="LOAD_NOW",
                                                    "One Time"="LOAD_ONCE",
                                                    "Weekly"="LOAD_WEEKLY",
                                                    "Biweekly"="LOAD_BIWEEKLY",
                                                    "1st and 15th"="LOAD_ON_DAY_1_AND_15",
                                                    "Monthly"="LOAD_MONTHLY")),
                                      textInput("txtStart", "Start Date"),
                                      textInput("txtEnd", "End Date")),
                             tabPanel("Withdraw Funds",
                                      id="tabWithdrawFunds",
                                      tags$br(),
                                      textInput("txtAmount", "Amount"),
                                      actionButton("btnWithdraw",
                                                   "Withdraw"))))
        )
    }
