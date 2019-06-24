# Setup  -----------------------------------------------------------------
#datajoin.zip
zipfile <- choose.files()
library(dplyr)
library(stringr)
library(xlsx)

#function for NAs replacement with the above value in the same dealnumber
usdealsnareplace <- function(deal) {
      dealnumber <- unique(deal[,"dealnumber"])
      for (i in dealnumber) {
            for (j in 1:ncol(deal)) {
                  if (!all(!is.na(dplyr::filter(deal, dealnumber == i)[,j])) &&
                      !all(is.na(dplyr::filter(deal, dealnumber == i)[,j]))) {
                        
                        temp <- dplyr::filter(deal, dealnumber == i)[1,j]
                        if(!is.na(temp)) {
                              deal[deal[,1]==i & 
                                         !is.na(deal[,1]) & 
                                         is.na(deal[,j]),j] <- temp
                              rm(temp)
                        }
                  }
            }
            rm(j)
      }
      rm(dealnumber)
      return(deal)
}
#function to define date variables
usdealsdate <- function(deal) {
      datec <- as.vector(which(grepl("date",x = colnames(deal), ignore.case = T)))
      for (i in datec) {
            deal[,i] <- as.Date(
                  as.numeric(deal[,i])-2,
                  origin =  "1900-01-01")
      }
      rm(i, datec)
      return(deal)
}
#function to convert string to numerics
usdealsvalues <- function(deal) {
      deal <- as.numeric(
            str_remove_all(
                  str_remove_all(
                        str_remove_all(deal,'\\*'),
                        ","),
                  " ")
      )
      return(deal)
}


# Clean Deal Data --------------------------------------------------------
deal <- read.csv2(file = unzip(zipfile, files = "dealdata.csv"),
                 header = T, 
                 stringsAsFactors = F,
                 colClasses = "character",
                 na.strings=c(""," ","NA","n.a."),
                 nrows = 200)

#Select variables
dealvariables <- c(
      "dealnumber",
      "dealvalueeur",
      "dealvaluenative",
      "dealequityvalueeur",
      "dealequityvalueeurnative",
      "nativecurrency",
      "daterumour",
      "dateannounced",
      "assumedcompletiondate",
      "datecompleted",
      "datelastdealstatus",
      "targetname",
      "targetcountrycode",
      "targetbvdid",
      "acquirorname",
      "acquirorcountrycode",
      "acquirorbvdidnumber",
      "groupacquirorname",
      "groupacquirorcountrycode",
      "groupacquirorbvdid",
      "vendorname",
      "vendorcountrycode",
      "vendorbvdid",
      "groupvendorname",
      "groupvendorcountrycode",
      "groupvendorbvdid",
      "dealstatus",
      "filename",
      "initialstake",
      "finalstake",
      "dealtype")
deal <- deal[,dealvariables]
rm(dealvariables)

#NAs replace with the above value in the same dealnumber
deal[,colnames(deal) != "initialstake" &
      colnames(deal) != "finalstake"] <- usdealsnareplace(deal[,colnames(deal) != "initialstake" &
                                                                  colnames(deal) != "finalstake"])

#Remove NA and repeated rows
deal <- deal[rowSums(is.na(select(deal,-filename))) != (ncol(deal)-1),]
deal <- unique(deal)

#Date format setup
deal <- usdealsdate(deal)

#Substitute Initial and Final Stakes Unknown % for NA
deal$initialstake <- as.numeric(deal$initialstake)
deal$finalstake <- as.numeric(deal$finalstake)

#Convert numerics
for (i in which(grepl("value",x = colnames(deal), ignore.case = T))) {
      deal[,i] <- usdealsvalues(deal[,i])
}
rm(i)



# Clean Fin Data --------------------------------------------------------
fin <- read.csv2(file = unzip(zipfile, files = "findata.csv"),
                 header = T, 
                 stringsAsFactors = F,
                 colClasses = "character",
                 na.strings=c(""," ","NA","n.a."),
                 nrows = 200)

#select variables
finvariables <- c(
      'dealnumber',
      'target_numberofemployees_year1',
      'target_cashflowpershare_year1',
      'target_dividendpershare_year1',
      'acquiror_numberofemployees_year1',
      'acquiror_cashflowpershare_year1',
      'acquiror_dividendpershare_year1',
      'target_currency_firstavailyr',
      'target_isinnumber',
      'target_typeofshare',
      'target_tickersymbol',
      'target_mainexchange',
      'target_listed',
      'acquiror_currency_firstavailyr',
      'acquiror_isinnumber',
      'acquiror_mainexchange',
      'acquiror_listed',
      'filename',
      'target_netprofit_eur_year1',
      'target_totalassets_eur_year1',
      'acquiror_netprofit_eur_year1',
      'acquiror_totalassets_eur_year1',
      'acquiror_ebitda_eur_year1',
      'target_ebitda_eur_year1'
      )

fin <- fin[,finvariables]
rm(finvariables)

#NAs replace with the above value in the same dealnumber
#fin <- usdealsnareplace(fin)

#Remove NA and repeated rows
fin <- fin[rowSums(is.na(select(fin,-filename))) != (ncol(fin)-1),]
fin <- unique(fin)

#Date format setup
fin <- usdealsdate(fin)


# Clean Own Data --------------------------------------------------------
own <- read.csv2(file = unzip(zipfile, files = "owndata.csv"),
                 header = T, 
                 stringsAsFactors = F,
                 colClasses = "character",
                 na.strings=c(""," ","NA","n.a."),
                 nrows = 200)

#select variables
ownvariables <- c(
      "dealnumber",
      "targetname",
      "targetbvdidnumber",
      "targetshareholdersname",
      "targetshareholdersbvdnumber",
      "targetshareholderstype",
      "targetshareholdersdirect",
      "targetshareholderstotal",
      "acquirorname",
      "acquirorbvdidnumber",
      "acquirorshareholdersname",
      "acquirorshareholdersbvdnumber",
      "acquirorshareholderstype",
      "acquirorshareholdersdirect",
      "acquirorshareholderstotal",
      "filename",
      'targetcountrycode',
      'acquirorcountrycode',
      'targetregionwithinacountry',
      'acquirorregionwithinacountry',
      'targetprimarynaics2017code',
      'acquirorprimarynaics2017code')


own <- own[,ownvariables]
rm(ownvariables)

#NAs replace with the above value in the same dealnumber
own[,colnames(own) != "targetshareholdersdirect" &
      colnames(own) != "targetshareholderstotal" &
      colnames(own) != "acquirorshareholdersdirect" &
      colnames(own) != "acquirorshareholderstotal"] <- usdealsnareplace(own[,colnames(own) != "targetshareholdersdirect" &
                                                                                  colnames(own) != "targetshareholderstotal" &
                                                                                  colnames(own) != "acquirorshareholdersdirect" &
                                                                                  colnames(own) != "acquirorshareholderstotal"])


#Remove NA and repeated rows
own <- own[rowSums(is.na(select(own,-filename))) != (ncol(own)-1),]
own <- unique(own)

#Date format setup
own <- usdealsdate(own)








# Ownership type identification --------------------------------------------------------
acquiror <- select(own,
                   dealnumber,
                   acquirorname,
                   acquirorbvdidnumber,
                   acquirorshareholdersname,
                   acquirorshareholdersbvdnumber,
                   acquirorshareholderstype,
                   acquirorshareholdersdirect,
                   acquirorshareholderstotal)
acquiror <- unique(acquiror)
write.xlsx2(x = acquiror,
            file = "ownership_identification_acquiror.xlsx",
            sheetName = "acquirorown")
rm(acquiror)

target <- select(own,
                   dealnumber,
                   targetname,
                   targetbvdidnumber,
                   targetshareholdersname,
                   targetshareholdersbvdnumber,
                   targetshareholderstype,
                   targetshareholdersdirect,
                   targetshareholderstotal)
target <- unique(target)
write.xlsx2(x = target,
            file = "ownership_identification_target.xlsx",
            sheetName = "targetown")
rm(target)


own <-  select(own,
            -targetshareholdersname,
            -targetshareholdersbvdnumber,
            -targetshareholderstype,
            -targetshareholdersdirect,
            -targetshareholderstotal,
            -acquirorshareholdersname,
            -acquirorshareholdersbvdnumber,
            -acquirorshareholderstype,
            -acquirorshareholdersdirect,
            -acquirorshareholderstotal)
own <- unique(own)