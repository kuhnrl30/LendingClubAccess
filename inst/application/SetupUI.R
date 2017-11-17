SetupUI<- function(id, label="Setup"){
    ns <- NS(id)

    tagList(
        tabPanel("Setup",
                 id="tabSetup",
                 textInput("txtAccountNo", "Account Number"),
                 textInput("txtKey", "API"))
    )
}
