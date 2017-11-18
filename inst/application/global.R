source("AccountSummUI.R")
# source("MarketUI.R")
# source("SetupUI.R")
# source("TransferUI.R")
library(shiny)
library(LendingClub)
library(LendingClubAccess)
library(markdown)
library(data.table)
library(dplyr)
# source("menuOptions.R")

status_opts<- c("All",
                "Current",
                "Issued",
                "In Fudning",
                "Fully Paid",
                "In Grace Period",
                "Late (16-30 days)",
                "Late (31-120 days)",
                "Charged Off")

PortfolioNames<- c("All",LendingClub::PortfoliosOwned()$content$portfolioName)
