#' @export
GUI_NotesOwned<- function(){
    LendingClub::NotesOwned()$content %>%
        select(loanId:paymentsReceived) %>%
        GUI_Headers()
}
