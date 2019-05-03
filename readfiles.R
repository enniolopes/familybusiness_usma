# title: "US DEALS"
# updates:
      #02-may-2019 - Ennio
            #read the USDEALS xlsx files
            #drop columns
            #replace blank values with the first value of the column for each deal number
            #loop to read all USDeals?.xlsx
      #03-may-2019 - Ennio
            #bug "missing values are not allowed in subscripted assignments of data frames" fixed (in USDEALS READ for loop)
            

# TO DO
      #Clean Deal type - minority % and set unique values
      #read all files from zip and merge
      #read and merge fin and own
      #upload and connect tidy data to a URL
      #deploy script to the cloud
      #shiny


# SETUP ------------------------------------------------------------
#local files
setwd("C:\\Users\\Ennio\\Google Drive\\Academico\\Assistencia pesquisa\\FB - MA")
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

#  USDEALS READ: -------------------------------------------------------

#loop to read all deal xlsx files compressed in zip
#a function could be created

start_time <- Sys.time()
dealdata <- NULL

for (n in 1:length(deal)) {
   unzip(zipfile, deal[n], overwrite = T)
   
   dealread <- read_xlsx(deal[n], sheet = "Results", col_names = T, na = "n.a.", col_types = rep("text",206), n_max = 20)
   dealread <- dealread[,c(1,2,3,4,5,6,7,8,9,10,11,12,15,16,17,19,20,25,26,27,30,33,40,41,42,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64)]
   dealread <- unique(dealread)
   
   #NAs replace with the above value in the same dealnumber
   dealnumber <- as.data.frame(unique(dealread[,2]))[,1]
   for (i in dealnumber) {
      for (j in 1:ncol(dealread)) {
         temp <- dplyr::filter(dealread, `Deal Number` == i)[[j]][1]
         dealread[dealread[,2]==i & is.na(dealread[,j]),j] <- temp
         rm(temp)
      }
      rm(j)
   }
   dealread <- unique(dealread)
   dealread$filename <- deal[n]
   
   dealdata <- bind_rows(dealdata, dealread)
   rm(dealread,dealnumber,i)
   file.remove(deal[n])
}

end_time <- Sys.time()
print(str_c("Running time: ", round(end_time - start_time,0), " min."))
rm(end_time, start_time,n)


#  USDEALS CLEAN: -------------------------------------------------------
write.csv2(dealdata, file = "dealdata_draft.csv", fileEncoding = "macroman")
