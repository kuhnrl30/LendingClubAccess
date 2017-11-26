# source("AccountSummUI.R")
# source("MarketUI.R")
# source("SetupUI.R")
# source("TransferUI.R")
# source("menuOptions.R")
library(tidyr)
library(LendingClub)
library(dplyr)
status_opts<- c("All",
                "Current",
                "Issued",
                "In Funding",
                "Fully Paid",
                "In Grace Period",
                "Late (16-30 days)",
                "Late (31-120 days)",
                "Charged Off")

PortfolioNames<- c("All",LendingClub::PortfoliosOwned()$content$portfolioName)

purpose_opts <- c("All",
                  "car",
                  "credit_card",
                  "debt_consolidation",
                  "house",
                  "home_improvement",
                  "major_purpose",
                  "medical",
                  "moving",
                  "small_business",
                  "vacation",
                  "other")

at_risk_status<- c("Late (16-30 days)",
                   "Late (31-120 days)",
                   "Charged Off")