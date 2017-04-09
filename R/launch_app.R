#' Lauch the shiny app
#'
#'  Opens a shiny app capable of retrieving Lending Club account data and to
#'  execute transactions.
#' @export
launch_app <- function(x, ...) {
    shiny::runApp(system.file("application", package = "LendingClubAccess"),
                  display.mode = "normal",
                  ...)
    }


