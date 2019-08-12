setwd("/home/suporte/Downloads/data_analysis/")

# SETUP ------------------------------------------------------------
#local files
library(stringr)
library(readxl)
library(utils)
library(dplyr)
library(xlsx)

# DEFINE FILES ------------------------------------------------------------

#Select the zipfile "USDEALS_WIN.zip":
zipfile <- "USDeals_WIN.zip"
#zipfile <- choose.files()
file_list <- unzip(zipfile = zipfile, list = T)["Name"]
file_list <- as.character(file_list[1:nrow(file_list),"Name"])


fin <- str_detect(file_list, regex("usdealsfin", ignore_case = TRUE))
own <- str_detect(file_list, regex("usdealsown", ignore_case = TRUE))
deal <- !(str_detect(file_list, regex("usdealsfin", ignore_case = TRUE)) | str_detect(file_list, regex("usdealsown", ignore_case = TRUE)))

fin <- file_list[fin]
own <- file_list[own]
deal <- file_list[deal]

#check
if(length(fin)+length(own)+length(deal) == length(file_list)) {
      print("file_list split successful")
      rm(file_list)
} else {
      print("file_list split error: check lines")
}

# USDEALS READ: -------------------------------------------------------

#loop to read all deal xlsx files compressed in zip
start_time <- Sys.time()
dealdata <- NULL
linescounter = 0
#time elapse to read: 
for (n in 1:length(deal)) {
   unzip(zipfile, deal[n], overwrite = T)
   dealread <- read_xlsx(deal[n],
                         sheet = "Results", 
                         col_names = T, 
                         na = "n.a.", 
                         col_types = rep("text",206))
   totalrows <- nrow(dealread)
   dealread <- dealread[rowSums(is.na(dealread)) != ncol(dealread),]
   dealread <- unique(dealread)
   linescounter = linescounter + totalrows - nrow(dealread) ; rm(totalrows)
   dealread$filename <- deal[n]
   dealdata <- bind_rows(dealdata, dealread)
   rm(dealread)
   file.remove(deal[n])
} ; rm(n)
end_time <- Sys.time()

print(str_c("Read files running time - initiated at: ", start_time, "finished at: ",end_time))
print(str_c("Total of rows removed: ", linescounter))
rm(end_time,start_time,linescounter)
unique(dealdata$filename)

# USDEALS TREAT: -------------------------------------------------------

colnames(dealdata) <- c(
   "dborder",
   "dealnumber",
   "dealvalueeur",
   "dealvaluenative",
   "dealequityvalueeur",
   "dealequityvalueeurnative",
   "dealenterprisevalueeur",
   "dealenterprisevaluenative",
   "dealmodelledenterprisevalueeur",
   "dealmodelledenterprisevaluenative",
   "dealtotaltargetvalueeur",
   "dealtotaltargetvaluenative",
   "modelledfeeincometheur",
   "asreportedfeeincometheur",
   "initialstake",
   "acquired stake",
   "finalstake",
   "irr",
   "nativecurrency",
   "dealtype",
   "dealsub-type",
   "dealfinancing",
   "dealmethodofpayment",
   "dealmethodofpaymentvaluetheur",
   "dealstatus",
   "daterumour",
   "dateannounced",
   "expectedcompletiondate",
   "assumedcompletiondate",
   "datecompleted",
   "postponeddate",
   "withdrawndate",
   "datelastdealstatus",
   "lastdealvalueofferpricebidpremiumupdatedate",
   "lastdealstatusupdatedate",
   "lastofstakeupdatedate",
   "lastacquirortargetvendorupdatedate",
   "lastadvisorupdatedate",
   "lastdealcommentrationaleupdatedate",
   "datelastupdate",
   "dealheadline",
   "dealtypeb",
   "dealstatusb",
   "dealvalueeurb",
   "targetname",
   "targetcountrycode",
   "targetbusinessdescription",
   "targetbvdid",
   "acquirorname",
   "acquirorcountrycode",
   "acquirorbusinessdescription",
   "acquirorbvdidnumber",
   "groupacquirorname",
   "groupacquirorcountrycode",
   "groupacquirorbusinessdescription",
   "groupacquirorbvdid",
   "vendorname",
   "vendorcountrycode",
   "vendorbusinessdescriptions",
   "vendorbvdid",
   "groupvendorname",
   "groupvendorcountrycode",
   "groupvendorbusinessdescription",
   "groupvendorbvdid",
   "regulatorybodyname",
   "regulatorybodycountry",
   "typeofdealopportunity",
   "pre-dealtargetoperatingrevenueturnovertheurquarter-1",
   "pre-dealtargetoperatingrevenueturnovertheurquarter-2",
   "pre-dealtargetoperatingrevenueturnovertheurquarter-3",
   "pre-dealtargetebitdatheurquarter-1",
   "pre-dealtargetebitdatheurquarter-2",
   "pre-dealtargetebitdatheurquarter-3",
   "pre-dealtargetebittheurquarter-1",
   "pre-dealtargetebittheurquarter-2",
   "pre-dealtargetebittheurquarter-3",
   "pre-dealtargetprofitbeforetaxtheurquarter-1",
   "pre-dealtargetprofitbeforetaxtheurquarter-2",
   "pre-dealtargetprofitbeforetaxtheurquarter-3",
   "pre-dealtargetprofitaftertaxtheurquarter-1",
   "pre-dealtargetprofitaftertaxtheurquarter-2",
   "pre-dealtargetprofitaftertaxtheurquarter-3",
   "pre-dealtargetnetprofittheurquarter-1",
   "pre-dealtargetnetprofittheurquarter-2",
   "pre-dealtargetnetprofittheurquarter-3",
   "pre-dealtargettotalassetstheurquarter-1",
   "pre-dealtargettotalassetstheurquarter-2",
   "pre-dealtargettotalassetstheurquarter-3",
   "pre-dealtargetnetassetstheurquarter-1",
   "pre-dealtargetnetassetstheurquarter-2",
   "pre-dealtargetnetassetstheurquarter-3",
   "pre-dealtargetshareholdersfundstheurquarter-1",
   "pre-dealtargetshareholdersfundstheurquarter-2",
   "pre-dealtargetshareholdersfundstheurquarter-3",
   "pre-dealtargetmarketcapitalisationlastavailableyeartheur",
   "pre-dealacquiroroperatingrevenueturnovertheurlastavailyr",
   "pre-dealacquiroroperatingrevenueturnovertheurquarter-1",
   "pre-dealacquiroroperatingrevenueturnovertheurquarter-2",
   "pre-dealacquiroroperatingrevenueturnovertheurquarter-3",
   "pre-dealacquirorebitdatheurlastavailyr",
   "pre-dealacquirorebitdatheurquarter-1",
   "pre-dealacquirorebitdatheurquarter-2",
   "pre-dealacquirorebitdatheurquarter-3",
   "pre-dealacquirorebittheurlastavailyr",
   "pre-dealacquirorebittheurquarter-1",
   "pre-dealacquirorebittheurquarter-2",
   "pre-dealacquirorebittheurquarter-3",
   "pre-dealacquirorprofitbeforetaxtheurlastavailyr",
   "pre-dealacquirorprofitbeforetaxtheurquarter-1",
   "pre-dealacquirorprofitbeforetaxtheurquarter-2",
   "pre-dealacquirorprofitbeforetaxtheurquarter-3",
   "pre-dealacquirorprofitaftertaxtheurlastavailyr",
   "pre-dealacquirorprofitaftertaxtheurquarter-1",
   "pre-dealacquirorprofitaftertaxtheurquarter-2",
   "pre-dealacquirorprofitaftertaxtheurquarter-3",
   "pre-dealacquirornetprofittheurlastavailyr",
   "pre-dealacquirornetprofittheurquarter-1",
   "pre-dealacquirornetprofittheurquarter-2",
   "pre-dealacquirornetprofittheurquarter-3",
   "pre-dealacquirortotalassetstheurlastavailyr",
   "pre-dealacquirortotalassetstheurquarter-1",
   "pre-dealacquirortotalassetstheurquarter-2",
   "pre-dealacquirortotalassetstheurquarter-3",
   "pre-dealacquirornetassetstheurlastavailyr",
   "pre-dealacquirornetassetstheurquarter-1",
   "pre-dealacquirornetassetstheurquarter-2",
   "pre-dealacquirornetassetstheurquarter-3",
   "pre-dealacquirorshareholdersfundstheurlastavailyr",
   "pre-dealacquirorshareholdersfundstheurquarter-1",
   "pre-dealacquirorshareholdersfundstheurquarter-2",
   "pre-dealacquirorshareholdersfundstheurquarter-3",
   "pre-dealacquirormarketcapitalisationlastavailableyeartheur",
   "post-dealtargetoperatingrevenueturnovertheurquarter1",
   "post-dealtargetoperatingrevenueturnovertheurquarter2",
   "post-dealtargetoperatingrevenueturnovertheurquarter3",
   "post-dealtargetebitdatheurquarter1",
   "post-dealtargetebitdatheurquarter2",
   "post-dealtargetebitdatheurquarter3",
   "post-dealtargetebittheurquarter1",
   "post-dealtargetebittheurquarter2",
   "post-dealtargetebittheurquarter3",
   "post-dealtargetprofitbeforetaxtheurquarter1",
   "post-dealtargetprofitbeforetaxtheurquarter2",
   "post-dealtargetprofitbeforetaxtheurquarter3",
   "post-dealtargetprofitaftertaxtheurquarter1",
   "post-dealtargetprofitaftertaxtheurquarter2",
   "post-dealtargetprofitaftertaxtheurquarter3",
   "post-dealtargetnetprofittheurquarter1",
   "post-dealtargetnetprofittheurquarter2",
   "post-dealtargetnetprofittheurquarter3",
   "post-dealtargettotalassetstheurquarter1",
   "post-dealtargettotalassetstheurquarter2",
   "post-dealtargettotalassetstheurquarter3",
   "post-dealtargetnetassetstheurquarter1",
   "post-dealtargetnetassetstheurquarter2",
   "post-dealtargetnetassetstheurquarter3",
   "post-dealtargetshareholderfundstheurquarter1",
   "post-dealtargetshareholderfundstheurquarter2",
   "post-dealtargetshareholderfundstheurquarter3",
   "post-dealtargetmarketcapitalisationfirstavailableyeartheur",
   "post-dealacquiroroperatingrevenueturnovertheurquarter1",
   "post-dealacquiroroperatingrevenueturnovertheurquarter2",
   "post-dealacquiroroperatingrevenueturnovertheurquarter3",
   "post-dealacquirorebitdatheurquarter1",
   "post-dealacquirorebitdatheurquarter2",
   "post-dealacquirorebitdatheurquarter3",
   "post-dealacquirorebittheurquarter1",
   "post-dealacquirorebittheurquarter2",
   "post-dealacquirorebittheurquarter3",
   "post-dealacquirorprofitbeforetaxtheurquarter1",
   "post-dealacquirorprofitbeforetaxtheurquarter2",
   "post-dealacquirorprofitbeforetaxtheurquarter3",
   "post-dealacquirorprofitaftertaxtheurquarter1",
   "post-dealacquirorprofitaftertaxtheurquarter2",
   "post-dealacquirorprofitaftertaxtheurquarter3",
   "post-dealacquirornetprofittheurquarter1",
   "post-dealacquirornetprofittheurquarter2",
   "post-dealacquirornetprofittheurquarter3",
   "post-dealacquirortotalassetstheurquarter1",
   "post-dealacquirortotalassetstheurquarter2",
   "post-dealacquirortotalassetstheurquarter3",
   "post-dealacquirornetassetstheurquarter1",
   "post-dealacquirornetassetstheurquarter2",
   "post-dealacquirornetassetstheurquarter3",
   "post-dealacquirorshareholderfundstheurquarter1",
   "post-dealacquirorshareholderfundstheurquarter2",
   "post-dealacquirorshareholderfundstheurquarter3",
   "post-dealacquirormarketcapitalisationfirstavailableyeartheur",
   "targetstockprice3monthspriortorumoureur",
   "targetstockprice3monthspriortoannouncementeur",
   "targetstockpricepriortorumoureur",
   "targetstockpricepriortoannouncementeur",
   "targetstockpriceatcompletiondateeur",
   "targetstockpriceaftercompletioneur",
   "targetstockprice1weekaftercompletioneur",
   "targetstockprice1monthaftercompletioneur",
   "acquirorstockprice3monthspriortorumoureur",
   "acquirorstockprice3monthspriortoannouncementeur",
   "acquirorstockpricepriortorumoureur",
   "acquirorstockpricepriortoannouncementeur",
   "acquirorstockpriceatcompletiondateeur",
   "acquirorstockpriceaftercompletioneur",
   "acquirorstockprice1weekaftercompletioneur",
   "acquirorstockprice1monthaftercompletioneur",
   "categoryofsource",
   "sourcedocumentation",
   "filename")

# USDEALS LOAD: -------------------------------------------------------
# for MacIOS use the parameter fileEncoding = "macroman"
#write.csv2(dealdata, file = "dealdataMACOS.csv", fileEncoding = "macroman")
write.csv2(dealdata, file = "dealdata.csv")
rm(dealdata, deal)


# USFIN READ: -------------------------------------------------------

#loop to read all fin xlsx files compressed in zip
start_time <- Sys.time()
findata <- NULL
linescounter = 0
#time elapse to read: 4 min.
for (n in 1:length(fin)) {
   unzip(zipfile, fin[n], overwrite = T)
   dealread <- read_xlsx(fin[n], 
                         sheet = "Results", 
                         col_names = T, 
                         na = "n.a.", 
                         col_types = rep("text",270))
   totalrows <- nrow(dealread)
   #Clean all missing values lines 
   dealread <- dealread[rowSums(
      is.na(select(dealread,
                   -1,
                   -2,
                   -`Target listed`,
                   -`Acquiror listed`))) != (ncol(dealread)-4),]
   
   
   dealread <- unique(dealread)
   linescounter = linescounter + totalrows - nrow(dealread) ; rm(totalrows)
   dealread$filename <- fin[n]
   findata <- bind_rows(findata, dealread)
   rm(dealread)
   file.remove(fin[n])
} ; rm(n)
end_time <- Sys.time()

print(str_c("Read files running time - initiated at: ", start_time, "finished at: ",end_time))
print(str_c("Total of rows removed: ", linescounter))
rm(end_time,start_time,linescounter)
unique(findata$filename)


# USFIN TREAT: -------------------------------------------------------

colnames(findata) <- c(
   'dborder',
   'dealnumber',
   'target_operatingrevenue_eur_year1',
   'target_operatingrevenue_eur_year2',
   'target_operatingrevenue_eur_quarter1',
   'target_operatingrevenue_eur_quarter2',
   'target_operatingrevenue_eur_quarter3',
   'target_operatingrevenue_eur_quarter4',
   'target_operatingrevenue_eur_quarter5',
   'target_operatingrevenue_eur_quarter6',
   'target_operatingrevenue_eur_quarter7',
   'target_operatingrevenue_eur_quarter8',
   'target_ebitda_eur_year1',
   'target_ebitda_eur_year2',
   'target_ebitda_eur_quarter1',
   'target_ebitda_eur_quarter2',
   'target_ebitda_eur_quarter3',
   'target_ebitda_eur_quarter4',
   'target_ebitda_eur_quarter5',
   'target_ebitda_eur_quarter6',
   'target_ebitda_eur_quarter7',
   'target_ebitda_eur_quarter8',
   'target_ebit_eur_year1',
   'target_ebit_eur_year2',
   'target_ebit_eur_quarter1',
   'target_ebit_eur_quarter2',
   'target_ebit_eur_quarter3',
   'target_ebit_eur_quarter4',
   'target_ebit_eur_quarter5',
   'target_ebit_eur_quarter6',
   'target_ebit_eur_quarter7',
   'target_ebit_eur_quarter8',
   'target_profitbeforetax_eur_year1',
   'target_profitbeforetax_eur_year2',
   'target_profitbeforetax_eur_quarter1',
   'target_profitbeforetax_eur_quarter2',
   'target_profitbeforetax_eur_quarter3',
   'target_profitbeforetax_eur_quarter4',
   'target_profitbeforetax_eur_quarter5',
   'target_profitbeforetax_eur_quarter6',
   'target_profitbeforetax_eur_quarter7',
   'target_profitbeforetax_eur_quarter8',
   'target_profitaftertax_eur_year1',
   'target_profitaftertax_eur_year2',
   'target_profitaftertax_eur_quarter1',
   'target_profitaftertax_eur_quarter2',
   'target_profitaftertax_eur_quarter3',
   'target_profitaftertax_eur_quarter4',
   'target_profitaftertax_eur_quarter5',
   'target_profitaftertax_eur_quarter6',
   'target_profitaftertax_eur_quarter7',
   'target_profitaftertax_eur_quarter8',
   'target_netprofit_eur_year1',
   'target_netprofit_eur_year2',
   'target_netprofit_eur_quarter1',
   'target_netprofit_eur_quarter2',
   'target_netprofit_eur_quarter3',
   'target_netprofit_eur_quarter4',
   'target_netprofit_eur_quarter5',
   'target_netprofit_eur_quarter6',
   'target_netprofit_eur_quarter7',
   'target_netprofit_eur_quarter8',
   'target_totalassets_eur_year1',
   'target_totalassets_eur_year2',
   'target_totalassets_eur_quarter1',
   'target_totalassets_eur_quarter2',
   'target_totalassets_eur_quarter3',
   'target_totalassets_eur_quarter4',
   'target_totalassets_eur_quarter5',
   'target_totalassets_eur_quarter6',
   'target_totalassets_eur_quarter7',
   'target_totalassets_eur_quarter8',
   'target_netassets_eur_year1',
   'target_netassets_eur_year2',
   'target_netassets_eur_quarter1',
   'target_netassets_eur_quarter2',
   'target_netassets_eur_quarter3',
   'target_netassets_eur_quarter4',
   'target_netassets_eur_quarter5',
   'target_netassets_eur_quarter6',
   'target_netassets_eur_quarter7',
   'target_netassets_eur_quarter8',
   'target_shareholdersfunds_eur_year1',
   'target_shareholdersfunds_eur_year2',
   'target_shareholdersfunds_eur_quarter1',
   'target_shareholdersfunds_eur_quarter2',
   'target_shareholdersfunds_eur_quarter3',
   'target_shareholdersfunds_eur_quarter4',
   'target_shareholdersfunds_eur_quarter5',
   'target_shareholdersfunds_eur_quarter6',
   'target_shareholdersfunds_eur_quarter7',
   'target_shareholdersfunds_eur_quarter8',
   'target_marketcapitalisation_eur_year1',
   'target_marketcapitalisation_eur_year2',
   'target_numberofemployees_year1',
   'target_numberofemployees_year2',
   'target_numberofemployees_quarter1',
   'target_numberofemployees_quarter2',
   'target_numberofemployees_quarter3',
   'target_numberofemployees_quarter4',
   'target_numberofemployees_quarter5',
   'target_numberofemployees_quarter6',
   'target_numberofemployees_quarter7',
   'target_numberofemployees_quarter8',
   'target_enterprisevalue_eur_year1',
   'target_enterprisevalue_eur_year2',
   'target_enterprisevalue_eur_quarter1',
   'target_enterprisevalue_eur_quarter2',
   'target_enterprisevalue_eur_quarter3',
   'target_enterprisevalue_eur_quarter4',
   'target_enterprisevalue_eur_quarter5',
   'target_enterprisevalue_eur_quarter6',
   'target_enterprisevalue_eur_quarter7',
   'target_enterprisevalue_eur_quarter8',
   'target_earningspershare_year1',
   'target_earningspershare_year2',
   'target_cashflowpershare_year1',
   'target_cashflowpershare_year2',
   'target_dividendpershare_year1',
   'target_dividendpershare_year2',
   'target_bookvaluepershare_year1',
   'target_bookvaluepershare_year2',
   'acquiror_operatingrevenue_eur_year1',
   'acquiror_operatingrevenue_eur_year2',
   'acquiror_operatingrevenue_eur_quarter1',
   'acquiror_operatingrevenue_eur_quarter2',
   'acquiror_operatingrevenue_eur_quarter3',
   'acquiror_operatingrevenue_eur_quarter4',
   'acquiror_operatingrevenue_eur_quarter5',
   'acquiror_operatingrevenue_eur_quarter6',
   'acquiror_operatingrevenue_eur_quarter7',
   'acquiror_operatingrevenue_eur_quarter8',
   'acquiror_ebitda_eur_year1',
   'acquiror_ebitda_eur_year2',
   'acquiror_ebitda_eur_quarter1',
   'acquiror_ebitda_eur_quarter2',
   'acquiror_ebitda_eur_quarter3',
   'acquiror_ebitda_eur_quarter4',
   'acquiror_ebitda_eur_quarter5',
   'acquiror_ebitda_eur_quarter6',
   'acquiror_ebitda_eur_quarter7',
   'acquiror_ebitda_eur_quarter8',
   'acquiror_ebit_eur_year1',
   'acquiror_ebit_eur_year2',
   'acquiror_ebit_eur_quarter1',
   'acquiror_ebit_eur_quarter2',
   'acquiror_ebit_eur_quarter3',
   'acquiror_ebit_eur_quarter4',
   'acquiror_ebit_eur_quarter5',
   'acquiror_ebit_eur_quarter6',
   'acquiror_ebit_eur_quarter7',
   'acquiror_ebit_eur_quarter8',
   'acquiror_profitbeforetax_eur_year1',
   'acquiror_profitbeforetax_eur_year1',
   'acquiror_profitbeforetax_eur_quarter1',
   'acquiror_profitbeforetax_eur_quarter2',
   'acquiror_profitbeforetax_eur_quarter3',
   'acquiror_profitbeforetax_eur_quarter4',
   'acquiror_profitbeforetax_eur_quarter5',
   'acquiror_profitbeforetax_eur_quarter6',
   'acquiror_profitbeforetax_eur_quarter7',
   'acquiror_profitbeforetax_eur_quarter8',
   'acquiror_profitaftertax_eur_year1',
   'acquiror_profitaftertax_eur_year2',
   'acquiror_profitaftertax_eur_quarter1',
   'acquiror_profitaftertax_eur_quarter2',
   'acquiror_profitaftertax_eur_quarter3',
   'acquiror_profitaftertax_eur_quarter4',
   'acquiror_profitaftertax_eur_quarter5',
   'acquiror_profitaftertax_eur_quarter6',
   'acquiror_profitaftertax_eur_quarter7',
   'acquiror_profitaftertax_eur_quarter8',
   'acquiror_netprofit_eur_year1',
   'acquiror_netprofit_eur_year2',
   'acquiror_netprofit_eur_quarter1',
   'acquiror_netprofit_eur_quarter2',
   'acquiror_netprofit_eur_quarter3',
   'acquiror_netprofit_eur_quarter4',
   'acquiror_netprofit_eur_quarter5',
   'acquiror_netprofit_eur_quarter6',
   'acquiror_netprofit_eur_quarter7',
   'acquiror_netprofit_eur_quarter8',
   'acquiror_totalassets_eur_year1',
   'acquiror_totalassets_eur_year2',
   'acquiror_totalassets_eur_quarter1',
   'acquiror_totalassets_eur_quarter2',
   'acquiror_totalassets_eur_quarter3',
   'acquiror_totalassets_eur_quarter4',
   'acquiror_totalassets_eur_quarter5',
   'acquiror_totalassets_eur_quarter6',
   'acquiror_totalassets_eur_quarter7',
   'acquiror_totalassets_eur_quarter8',
   'acquiror_netassets_eur_year1',
   'acquiror_netassets_eur_year2',
   'acquiror_netassets_eur_quarter1',
   'acquiror_netassets_eur_quarter2',
   'acquiror_netassets_eur_quarter3',
   'acquiror_netassets_eur_quarter4',
   'acquiror_netassets_eur_quarter5',
   'acquiror_netassets_eur_quarter6',
   'acquiror_netassets_eur_quarter7',
   'acquiror_netassets_eur_quarter8',
   'acquiror_shareholdersfunds_eur_year1',
   'acquiror_shareholdersfunds_eur_year2',
   'acquiror_shareholdersfunds_eur_quarter1',
   'acquiror_shareholdersfunds_eur_quarter2',
   'acquiror_shareholdersfunds_eur_quarter3',
   'acquiror_shareholdersfunds_eur_quarter4',
   'acquiror_shareholdersfunds_eur_quarter5',
   'acquiror_shareholdersfunds_eur_quarter6',
   'acquiror_shareholdersfunds_eur_quarter7',
   'acquiror_shareholdersfunds_eur_quarter8',
   'acquiror_marketcapitalisation_eur_year1',
   'acquiror_marketcapitalisation_eur_year2',
   'acquiror_numberofemployees_year1',
   'acquiror_numberofemployees_year2',
   'acquiror_numberofemployees_quarter1',
   'acquiror_numberofemployees_quarter2',
   'acquiror_numberofemployees_quarter3',
   'acquiror_numberofemployees_quarter4',
   'acquiror_numberofemployees_quarter5',
   'acquiror_numberofemployees_quarter6',
   'acquiror_numberofemployees_quarter7',
   'acquiror_numberofemployees_quarter8',
   'acquiror_enterprisevalue_eur_year1',
   'acquiror_enterprisevalue_eur_year2',
   'acquiror_enterprisevalue_eur_quarter1',
   'acquiror_enterprisevalue_eur_quarter2',
   'acquiror_enterprisevalue_eur_quarter3',
   'acquiror_enterprisevalue_eur_quarter4',
   'acquiror_enterprisevalue_eur_quarter5',
   'acquiror_enterprisevalue_eur_quarter6',
   'acquiror_enterprisevalue_eur_quarter7',
   'acquiror_enterprisevalue_eur_quarter8',
   'acquiror_earningspershare_year1',
   'acquiror_earningspershare_year2',
   'acquiror_cashflowpershare_year1',
   'acquiror_cashflowpershare_year2',
   'acquiror_dividendpershare_year1',
   'acquiror_dividendpershare_year2',
   'acquiror_bookvaluepershare_year1',
   'acquiror_bookvaluepershare_year2',
   'target_numberofoutstandingshares_firstavailyr',
   'target_dateofoutstandingshares',
   'target_currency_firstavailyr',
   'target_currentmarketcapitalisation_lcufirstavailyr',
   'target_dateofcurrentmarketcapitalisation',
   'target_typeofshare',
   'target_isinnumber',
   'target_tickersymbol',
   'target_nominalvalue',
   'target_mainexchange',
   'target_stockexchangelisted',
   'target_stockindexinformation',
   'target_ipodate',
   'target_listed',
   'acquiror_numberofoutstandingshares_firstavailyr',
   'acquiror_dateofoutstandingshares',
   'acquiror_currency_firstavailyr',
   'acquiror_currentmarketcapitalisation_lcufirstavailyr',
   'acquiror_dateofcurrentmarketcapitalisation',
   'acquiror_typeofshare',
   'acquiror_isinnumber',
   'acquiror_tickersymbol',
   'acquiror_nominalvalue',
   'acquiror_mainexchange',
   'acquiror_stockexchangelisted',
   'acquiror_stockindexinformation',
   'acquiror_ipodate',
   'acquiror_listed',
   'filename')


totalna <- sum(rowSums(is.na(findata)))
#Trim number variables
system.time({
   for (i in 1:242) {
      findata[[i]] <- as.numeric(findata[[i]])
   }
}) ; rm(i)

print(str_c("Total of NAs inserted: ",
            totalna - sum(rowSums(is.na(findata))),
            " or ", round((totalna/sum(rowSums(is.na(findata))) - 1)*100,2),
            "%"))
totalna <- sum(rowSums(is.na(findata)))


#Define date variables
datec <- as.vector(which(grepl("date",x = colnames(findata), ignore.case = T)))
for (i in datec) {
   findata[[i]] <- as.Date(findata[[258]], '%d/%m/%Y')
} ; rm(i, datec)

print(str_c("Total of NAs inserted: ",
            totalna - sum(rowSums(is.na(findata))),
            " or ", round((totalna/sum(rowSums(is.na(findata))) - 1)*100,2),
            "%"))
rm(totalna)


# USFIN LOAD: -------------------------------------------------------
# for MacIOS use the parameter fileEncoding = "macroman"
write.csv2(findata, file = "findata.csv")
rm(findata, fin)


# USOWN READ: -------------------------------------------------------
#loop to read all deal xlsx files compressed in zip
start_time <- Sys.time()
owndata <- NULL
linescounter = 0
#time elapse to read: 
for (n in 1:length(own)) {
   unzip(zipfile, own[n], overwrite = T)
   dealread <- read_xlsx(own[n],
                         sheet = "Results",
                         col_names = T,
                         na = "n.a.",
                         col_types = rep("text",72))
   totalrows <- nrow(dealread)
   dealread <- dealread[rowSums(
      is.na(select(dealread,-1,-2,))) != (ncol(dealread)-2),]
   dealread <- unique(dealread)
   linescounter = linescounter + totalrows - nrow(dealread) ; rm(totalrows)
   dealread$filename <- own[n]
   owndata <- bind_rows(owndata, dealread)
   rm(dealread)
   file.remove(own[n])
} ; rm(n)
end_time <- Sys.time()

print(str_c("Read files running time - initiated at: ", start_time, "finished at: ",end_time))
print(str_c("Total of rows removed: ", linescounter))
rm(end_time,start_time,linescounter)
unique(owndata$filename)

# USOWN TREAT: -------------------------------------------------------
colnames(owndata) <- c(
   "dborder",
   "dealnumber",
   "targetname",
   "targetbvdidnumber",
   "targetpostcode",
   "targetcity",
   "targetregionwithinacountry",
   "targetcountry",
   "targetcountrycode",
   "acquirorname",
   "acquirorbvdidnumber",
   "acquirorpostcode",
   "acquirorcity",
   "acquirorregionwithinacountry",
   "acquirorcountry",
   "acquirorcountrycode",
   "targetstatus",
   "targetentitytype",
   "targetlegalform",
   "targetdateofincorporation",
   "targetbvdindependenceindicator",
   "targetavailableaccountstypes",
   "targetfilingtype",
   "targetlatestaccountsdate",
   "targetaccountspublishedin",
   "acquirorstatus",
   "acquirorentitytype",
   "acquirorlegalform",
   "acquirordateofincorporation",
   "acquirorbvdindependenceindicator",
   "acquiroravailableaccountstypes",
   "acquirorfilingtype",
   "acquirorlatestaccountsdate",
   "acquiroraccountspublishedin",
   "targetussicdescriptions",
   "targetussiccodes",
   "targetprimarynaics2017code",
   "targetprimarynaics2017description",
   "targetnaics2017codes",
   "targetnaics2017descriptions",
   "targetprimaryuksic2007code",
   "targetprimaryuksic2007description",
   "acquirorussiccodes",
   "acquirorussicdescriptions",
   "acquirorprimaryuksic2007code",
   "acquirorprimaryuksic2007description",
   "acquirorprimarynaics2017code",
   "acquirorprimarynaics2017description",
   "acquirornaics2017codes",
   "acquirornaics2017descriptions",
   "targetshareholdersname",
   "targetshareholdersbvdnumber",
   "targetshareholdersisocountrycode",
   "targetshareholderstype",
   "targetshareholdersdirect",
   "targetshareholderstotal",
   "targetshareholderssource",
   "targetshareholdersdate",
   "targetshareholdersoperatingrevenuemusd",
   "targetshareholderstotalassetsmusd",
   "targetshareholdersnoofemployees",
   "acquirorshareholdersname",
   "acquirorshareholdersbvdnumber",
   "acquirorshareholdersisocountrycode",
   "acquirorshareholderstype",
   "acquirorshareholdersdirect",
   "acquirorshareholderstotal",
   "acquirorshareholderssource",
   "acquirorshareholdersdate",
   "acquirorshareholdersoperatingrevenuemusd",
   "acquirorshareholderstotalassetsmusd",
   "acquirorshareholdersnoofemployees",
   "filename")


# USOWN LOAD: -------------------------------------------------------
# for MacIOS use the parameter fileEncoding = "macroman"
write.csv2(owndata, file = "owndata.csv")
rm(owndata, own, zipfile)