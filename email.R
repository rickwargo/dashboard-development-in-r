library(rmarkdown)
library(mailR)
library(knitr)

setwd("~/Code/R/AppleHealthData")

knit2html("email.Rmd", options = "")

user = .rs.askForPassword("Office 365 User")
pw = .rs.askForPassword("Office 365 Password")

send.mail(from = user,
          to = user,
          subject = paste("Your Customized Health Data Report for the Period ending", format(Sys.Date(), "%A, %B %d, %Y")),
          html = TRUE,
          inline = TRUE,
          body = "email.html",
          smtp = list(host.name = "smtp.office365.com", port = 587, user.name = user, passwd = pw, tls = TRUE),
          authenticate = TRUE,
          send = TRUE)
