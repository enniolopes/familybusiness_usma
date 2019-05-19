# title: "US DEALS"
# updates:
      #02-may-2019: Ennio
            #read the USDEALS xlsx files
            #drop columns
            #replace blank values with the first value of the column for each deal number
            #loop to read all USDeals.xlsx
      #03-may-2019: Ennio
            #bug "missing values are not allowed in subscripted assignments of data frames" fixed (in USDEALS READ for loop)
      #17-may-2019: Ennio
            #Treat data: colnames
            #Treat data: clean duplicated dealtype, dealvalue
            #Treat data: trim and declare values variables
            #Treat data: declare date variables
      #18-may-2019: Ennio
            #Test final deal data and integrity check
            #write csv for clean deal data (dealdata.csv)


# SETUP ------------------------------------------------------------
#local files
library(stringr)
library(readxl)
library(utils)
library(dplyr)
library(xlsx)

# DEFINE FILES ------------------------------------------------------------

#Select the zipfile "USDEALS_WIN.zip":
zipfile <- choose.files()
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

#  USDEALS LOAD: -------------------------------------------------------

#loop to read all deal xlsx files compressed in zip
start_time <- Sys.time()
dealdata <- NULL

system.time({
for (n in 1:length(deal)) {
   unzip(zipfile, deal[n], overwrite = T)
   dealread <- read_xlsx(deal[n], 
                         sheet = "Results", 
                         col_names = T, 
                         na = "n.a.", 
                         col_types = rep("text",206))
   dealread <- dealread[,c(1,2,3,4,5,6,7,8,9,10,11,12,15,16,17,19,20,25,26,27,30,33,40,41,42,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64)]
   dealread$filename <- deal[n]

   #NAs replace with the above value in the same dealnumber
   dealnumber <- as.data.frame(unique(dealread[,2]), stringsAsFactors = F)[,1]

      for (i in dealnumber) {
         for (j in 1:ncol(dealread)) {
            temp <- dplyr::filter(dealread, `Deal Number` == i)[[j]][1]
            if(!is.na(temp)) {
               dealread[dealread[,2]==i & 
                           !is.na(dealread[,2]) & 
                           is.na(dealread[,j]),j] <- temp
               rm(temp)
            }
         }
         rm(j)
      }
      rm(dealnumber)

   dealdata <- bind_rows(dealdata, dealread)
   rm(dealread,i)
   file.remove(deal[n])
}
})

dealdata <- dealdata[rowSums(is.na(select(dealdata,-filename))) != (ncol(dealdata)-1),]
dealdata <- unique(dealdata)

end_time <- Sys.time()
print(str_c("Read files running time: ", round(end_time - start_time,0), " min."))
rm(end_time,start_time,n)
unique(dealdata$filename)

#  USDEALS TREAT: -------------------------------------------------------

colnames(dealdata) <- c(
   "dborder",
   "dealnumber",
   "dealvalueEUR",
   "dealvalueNative",
   "dealequityvalueEUR",
   "dealequityvalueEURNative",
   "dealenterprisevalueEUR",
   "dealenterprisevalueNative",
   "dealmodelledenterprisevalueEUR",
   "dealmodelledenterprisevalueNative",
   "dealtotaltargetvalueEUR",
   "dealtotaltargetvalueNative",
   "initialstake",
   "acquired stake",
   "finalstake",
   "nativecurrency",
   "dealtype",
   "dealstatus",
   "daterumour",
   "dateannounced",
   "datecompleted",
   "datelastdealstatus",
   "datelastupdate",
   "dealheadline",
   "dealtypeb",
   "dealvalueEURb",
   "targetname",
   "targetcountrycode",
   "targetbusinessdescription",
   "targetBvDID",
   "acquirorname",
   "acquirorcountrycode",
   "acquirorbusinessdescription",
   "acquirorBvDIDnumber",
   "groupacquirorname",
   "groupacquirorcountrycode",
   "groupacquirorbusinessdescription",
   "groupacquirorBvDID",
   "vendorname",
   "vendorcountrycode",
   "vendorbusinessdescription(s)",
   "vendorBvDID",
   "groupvendorname",
   "groupvendorcountrycode",
   "groupvendorbusinessdescription",
   "groupvendorBvDID",
   "filename")

#Remove dealtypeb if it is duplicated
if(all(dealdata$dealtype == dealdata$dealtypeb, na.rm = T)) {
   dealdata <- select(dealdata, -dealtypeb)
}

#Remove dealvalurEURb if it is duplicated
if(all(dealdata$dealvalueEUR == dealdata$dealvalueEURb, na.rm = T)) {
   dealdata <- select(dealdata, -dealvalueEURb)
}

#Trim number variables
values <- as.vector(which(grepl("value",x = colnames(dealdata), ignore.case = T)))
system.time({
   for (i in values) {
      for(j in 1:nrow(dealdata)) {
         dealdata[j,i] <-  as.numeric(
            trimws(
               gsub("[^0-9\\.]", "", dealdata[j,i])))
      }
      rm(j)
   }
   rm(i,values)
})


#Define date variables
datec <- as.vector(which(grepl("date",x = colnames(dealdata), ignore.case = T)))
for (i in datec) {
   dealdata[,i] <- as.Date(
      as.numeric(
         as.data.frame(dealdata[,i], stringsAsFactor = F)[,1])-2,
      origin="1900-01-01")
}
rm(i, datec)


#  USDEALS LOAD: -------------------------------------------------------
# for MacIOS use the parameter fileEncoding = "macroman"
write.csv2(dealdata, file = "dealdata.csv")
rm(dealdata)