---
title: "Getting Started"
output: html_document
---



### Coming Soon!

...but here's the minimal code to start the app.


```r
library(LendingClub)
library(LendingClubAccess)

LC_CRED<- MakeCredential("InvestorID",
                         "APIKey")
launch_app()
```

To open it directly in the browswer, add a few arguments to the launch function.



```r
launch_app(host="127.0.0.1",port=5209, launch.browser = T)
```
