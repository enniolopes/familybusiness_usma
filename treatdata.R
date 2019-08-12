##Pendencias
#join fin data with deals
setwd("/home/suporte/Downloads/data_analysis/")
library(svMisc)
# Setup  -----------------------------------------------------------------
      zipfile <- "datajoin.zip"
      #zipfile <- choose.files()
      library(dplyr)
      library(stringr)
      library(xlsx)
      library(tidyr)
      library(tidytext)
      
      #function for NULL replacement with NA
      dealsnullreplace <- function(deal) {
         for(i in 1:nrow(deal)) {
            for (j in 1:ncol(deal)) {
               if (is.null(deal[i,j])) {
                  deal[i,j] <- NA
               }
            }
         }
         return(deal)
      }
      #function for NAs replacement with the above value in the same dealnumber
      dealsnareplace <- function(deal,columns) {
         dealnumber <- unique(deal[,"dealnumber"])
         for (i in dealnumber) {
            if (nrow(deal[deal$dealnumber == i,]) > 1) {
               dealtemp <- deal[deal$dealnumber == i,]
               for (n in 2:nrow(dealtemp)) {
                  for (j in columns) {
                     if (is.na(dealtemp[n,j])) {
                        dealtemp[n,j] <- dealtemp[n-1,j]
                     }
                  }
               }
               deal[deal$dealnumber == i,] <- dealtemp
               rm(dealtemp)
            }
         }
         rm(dealnumber)
         return(deal)
      }
      #function to define date variables
      dealsdate <- function(deal) {
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
      dealsvalues <- function(deal) {
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
         blank.lines.skip = T,
         header = T, 
         stringsAsFactors = F,
         colClasses = "character",
         na.strings=c(""," ","NA","n.a."))
      file.remove("dealdata.csv")
      
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
            "dealstatus",
            "filename",
            "initialstake",
            "finalstake",
            "dealtype")
      deal <- deal[,dealvariables]
      rm(dealvariables)
      
      #remove rows that dealnumber is NA
      deal <- deal[!is.na(deal$dealnumber),]
      
      #NAs replace with the above value in the same dealnumber
      start_time <- Sys.time()
      nanumber <- sum(rowSums(is.na(deal)))
      deal <- dealsnareplace(deal,c(1:13,15:16))
      end_time <- Sys.time()
      print(str_c("Read files running time - initiated at: ", start_time, "finished at: ",end_time))
      print(str_c("Total of NAs replaced: ", nanumber - sum(rowSums(is.na(deal)))))
      rm(start_time, end_time, nanumber)
      
      #Remove NA and repeated rows
      deal <- deal[rowSums(is.na(select(deal,-filename))) != (ncol(deal)-1),]
      deal <- unique(deal)
      
      #Date format setup
      deal <- dealsdate(deal)
      
      
      #Substitute Initial and Final Stakes Unknown % for NA
      deal[deal$initialstake=="Unknown %" &
              !is.na(deal$initialstake),"initialstake"] <- NA
      deal[deal$initialstake=="Unknown Minority" &
              !is.na(deal$initialstake),"initialstake"] <- 1
      deal[deal$initialstake=="Unknown majority" &
              !is.na(deal$initialstake),"initialstake"] <- 51
      deal$initialstake <- str_replace_all(deal$initialstake, pattern = ".00000", replacement = "")
      
      deal[deal$finalstake=="Unknown %" &
              !is.na(deal$finalstake),"finalstake"] <- NA
      deal[deal$finalstake=="Unknown minority" &
              !is.na(deal$finalstake),"finalstake"] <- 1
      deal[deal$finalstake=="Unknown majority" &
              !is.na(deal$finalstake),"finalstake"] <- 51
      deal$finalstake <- str_replace_all(deal$finalstake, pattern = ".00000", replacement = "")
      
      unique(c(deal$initialstake[is.na(as.numeric(deal$initialstake))],
         deal$finalstake[is.na(as.numeric(deal$finalstake))]))
      
      deal$initialstake <- as.numeric(deal$initialstake)
      deal$finalstake <- as.numeric(deal$finalstake)
      
      #Convert numerics
      for (i in which(grepl("value",x = colnames(deal), ignore.case = T))) {
            deal[,i] <- dealsvalues(deal[,i])
      } ; rm(i)
      
      
      #convert dealtype to initialstake_est and finalstake_est
      dealtype <- unzip(zipfile, files = "dealdata.csv") %>%
         readr::read_csv2(col_names = T)
      dealtype <- unique(dealtype[,21])
      dealtype_merge <- tibble(dealtype,
                               initialstake_est = rep(NA,nrow(dealtype)),
                               finalstake_est = rep(NA,nrow(dealtype)),
                               stakevariation_est = rep(NA,nrow(dealtype)))
      
      for (i in 1:nrow(dealtype)) {
      ## clean data and format token text ##
         temp <- dealtype[i,]
         temp[[1]] <- temp[[1]] %>%
            tolower() %>%
            str_remove_all(pattern = "bid [123456789]") %>% #remove bid number for no inconsistences with % extracts
            str_remove_all(pattern = "%acquisition") %>%
            str_remove_all(pattern = "%merger") %>%
            str_remove_all(pattern = "%institutional") %>%
            str_remove_all(pattern = "%")
      
         temp <- temp %>%
            unnest_tokens(word, dealtype, to_lower = T) #create token
      
      
      ## Grep stakes values ##
         
         if (sum(temp == "from") == 1 && sum(temp == "to") == 1) { #grep initial and final stakes
            nbr <- temp[[1]] %>%
               as.numeric()
      
            dealtype_merge$initialstake_est[i] <- nbr[!is.na(nbr)][1]
            dealtype_merge$finalstake_est[i] <- nbr[!is.na(nbr)][2]
            rm(nbr)
         } else if ((sum(temp=="acquisition")>0 | ##grep stakes variation
                     sum(temp=="increase")>0 |
                     sum(temp=="increased")>0 |
                     sum(temp=="buyback")>0 |
                     sum(temp=="buy-out")>0 |
                     sum(temp=="buy")>0 |
                     sum(temp=="merger")>0 |
                     sum(temp=="venture")>0) &&
                  sum(!is.na(as.numeric(temp[[1]])))==1) {
            nbr <- temp[[1]] %>%
               as.numeric()
            
            dealtype_merge$stakevariation_est[i] <- nbr[!is.na(nbr)][1]
            rm(nbr)
         } else if (sum(temp=="minority")==1 &&
         sum(!is.na(as.numeric(temp[[1]])))==1) { #grep final stake from minority
            nbr <- temp[[1]] %>%
               as.numeric()
            dealtype_merge$initialstake_est[i] <- 0
            dealtype_merge$finalstake_est[i] <- nbr[!is.na(nbr)][1]
            rm(nbr)
         } else if (sum(!is.na(as.numeric(temp[[1]])))>1) { #grep major value
            nbr <- temp[[1]] %>%
               as.numeric()
            nbr <- max(nbr, na.rm = T)
            
            dealtype_merge$finalstake_est[i] <- nbr
            rm(nbr)
         } else if (sum(!is.na(as.numeric(temp[[1]])))==1) { #grep value to stake variation
            nbr <- temp[[1]] %>%
               as.numeric()
            
            dealtype_merge$finalstake_est[i] <- nbr[!is.na(nbr)][1]
            rm(nbr)
         } else if (sum(temp=="minority")>0 &&
                    (sum(temp=="majority")==0 |
                     sum(temp=="controlling")==0)) { #minority without values
            dealtype_merge$initialstake_est[i] <- 0
            dealtype_merge$finalstake_est[i] <- 1
         }  else if ((sum(temp=="majority")>0 |
                     sum(temp=="controlling")>0) &&
                     sum(temp=="minority")==0) { #majority without values
            dealtype_merge$finalstake_est[i] <- 51
         }
         
         
      
      } ; rm(i,temp)
      
      
      unique(dealtype_merge[is.na(dealtype_merge$initialstake_est) &
                               is.na(dealtype_merge$finalstake_est) &
                               is.na(dealtype_merge$stakevariation_est),1])
      rm(dealtype)
      
      # For stake variation equal to 100, final stake equal to 100
      dealtype_merge[dealtype_merge[,4] == 100 &
                        !is.na(dealtype_merge[,4]) &
                        is.na(dealtype_merge[,3]),3] <- 100
      
      ## Join dealtype_merge with deal ##
      dealtype_merge <- cbind(dealtype_merge[[1]],as.data.frame(dealtype_merge[,2:4], stringAsFactors = F))
      deal <- left_join(x = deal, 
                        y = dealtype_merge,
                        by = "dealtype")
      rm(dealtype_merge)
      
      ## complete estimate stakes with observed initial and final stakes
      deal[!is.na(deal$initialstake),"initialstake_est"] <- deal[!is.na(deal$initialstake),"initialstake"]
      deal[!is.na(deal$finalstake),"finalstake_est"] <- deal[!is.na(deal$finalstake),"finalstake"]
      
      #Remove again repeated rows
      deal <- unique(deal)
      
# Clean Own Data --------------------------------------------------------
      own <- read.csv2(file = unzip(zipfile, files = "owndata.csv"),
                       header = T, 
                       stringsAsFactors = F,
                       colClasses = "character",
                       na.strings=c(""," ","NA","n.a.","-"))
      file.remove("owndata.csv")
      
      #select variables
      ownvariables <- c(
            "dealnumber",
            "targetname",
            "targetbvdidnumber",
            "targetshareholdersname",
            "targetshareholdersbvdnumber",
            "targetshareholderstype",
            "targetshareholdersdirect",
            "acquirorname",
            "acquirorbvdidnumber",
            "acquirorshareholdersname",
            "acquirorshareholdersbvdnumber",
            "acquirorshareholderstype",
            "acquirorshareholdersdirect",
            'targetcountrycode',
            'acquirorcountrycode',
            'targetregionwithinacountry',
            'acquirorregionwithinacountry',
            'targetprimarynaics2017code',
            'acquirorprimarynaics2017code')
      
      own <- own[,ownvariables]
      rm(ownvariables)
      
      #NAs replace with the above value in the same dealnumber
      ownfilter <- c(
         "dealnumber",
         "targetname",
         "targetshareholdersname",
         "targetshareholdersbvdnumber",
         "targetshareholderstype",
         "acquirorname",
         "acquirorshareholdersname",
         "acquirorshareholdersbvdnumber",
         "acquirorshareholderstype",
         "targetcountrycode",
         "acquirorcountrycode",
         "targetregionwithinacountry",
         "acquirorregionwithinacountry",
         "targetprimarynaics2017code",
         "acquirorprimarynaics2017code"
      )
      start_time <- Sys.time()
      nanumber <- sum(rowSums(is.na(own)))
      own <- dealsnareplace(own,ownfilter)
      end_time <- Sys.time()
      print(str_c("Read files running time - initiated at: ", start_time, "finished at: ",end_time))
      print(str_c("Total of NAs replaced: ", nanumber - sum(rowSums(is.na(own)))))
      rm(start_time, end_time, nanumber)
      
      #Remove NA and repeated rows
      own <- own[rowSums(is.na(own)) != (ncol(own)-1),]
      own <- unique(own)
      
      #Date format setup
      own <- dealsdate(own)
      
      
      #ownership direct
         #remove ±
         own$targetshareholdersdirect <- str_remove(own$targetshareholdersdirect, "±")
      
         #replace '-' with NA
         own$targetshareholdersdirect[own$targetshareholdersdirect == "-"] <- NA
      
         #replace '<' with value plus 0.1%
         own$targetshareholdersdirect[
            grep("<", own$targetshareholdersdirect, ignore.case = T)] <- 
            own$targetshareholdersdirect[
                  grep("<", own$targetshareholdersdirect, ignore.case = T)] %>%
                  str_remove("<") %>%
                  as.numeric() %>%
                  -0.1
            
         #replace '>' with value plus 0.1%
         own$targetshareholdersdirect[
            grep(">", own$targetshareholdersdirect, ignore.case = T)] <- 
            own$targetshareholdersdirect[
               grep(">", own$targetshareholdersdirect, ignore.case = T)] %>%
            str_remove(">") %>%
            as.numeric() %>%
            +0.1
         
         #replace "NG" with 0.1
         own$targetshareholdersdirect[own$targetshareholdersdirect == "NG"] <- 0.1
         #replace "MO" with 51
         own$targetshareholdersdirect[own$targetshareholdersdirect == "MO"] <- 51
         #replace "WO" with 100
         own$targetshareholdersdirect[own$targetshareholdersdirect == "WO"] <- 100
         #replace "GP" with NA
         own$targetshareholdersdirect[own$targetshareholdersdirect == "GP"] <- NA
         #replace "FC" with NA
         own$targetshareholdersdirect[own$targetshareholdersdirect == "FC"] <- NA
      
# Ownership type identification --------------------------------------------------------
         own$targetshareholderstype[
            own$targetshareholderstype == "Other unnamed shareholders, aggregated" & 
               !is.na(own$targetshareholderstype)] <- "FREE-FLOAT"
         own$targetshareholderstype[
            own$targetshareholderstype == "Public" & 
               !is.na(own$targetshareholderstype)] <- "FREE-FLOAT"
         own$targetshareholderstype[
            own$targetshareholderstype == "Unnamed private shareholders, aggregated" & 
               !is.na(own$targetshareholderstype)] <- "FREE-FLOAT"
         own$targetshareholderstype[
            own$targetshareholderstype == "One or more named individuals or families" & 
               !is.na(own$targetshareholderstype)] <- "Family"
      
         own$acquirorshareholderstype[
            own$acquirorshareholderstype == "Other unnamed shareholders, aggregated" & 
               !is.na(own$acquirorshareholderstype)] <- "FREE-FLOAT"
         own$acquirorshareholderstype[
            own$acquirorshareholderstype == "Public" & 
               !is.na(own$acquirorshareholderstype)] <- "FREE-FLOAT"
         own$acquirorshareholderstype[
            own$acquirorshareholderstype == "Unnamed private shareholders, aggregated" & 
               !is.na(own$acquirorshareholderstype)] <- "FREE-FLOAT"
         own$acquirorshareholderstype[
            own$acquirorshareholderstype == "One or more named individuals or families" & 
               !is.na(own$acquirorshareholderstype)] <- "Family"
      
      
# Ownership shareholders reshaping long format to wide format --------------------------------------------------------
      
      ## filter only the 3 major direct shareholders ##
      ##id: dealnumber
      if (sum(is.na(own$dealnumber))==0) {
         print("no missing values observed")
      } else {
         print("missing values observed:")
         own$targetname[is.na(own$dealnumber)]
      }
      
      
      ## split own to target and acquiror files ##
      colnames(own)
      
      owntarget <- select(own,
         dealnumber,
         targetbvdidnumber,
         acquirorbvdidnumber,
         targetname,
         targetshareholdersname,
         targetshareholdersbvdnumber,
         targetcountrycode,
         targetregionwithinacountry,
         targetprimarynaics2017code,
         targetshareholderstype,
         targetshareholdersdirect)
      owntarget <- unique(owntarget)
      
      ownacquiror <- select(own,
         dealnumber,
         targetbvdidnumber,
         acquirorbvdidnumber,
         acquirorname,
         acquirorshareholdersname,
         acquirorshareholdersbvdnumber,
         acquirorcountrycode,
         acquirorregionwithinacountry,
         acquirorprimarynaics2017code,
         acquirorshareholderstype,
         acquirorshareholdersdirect)
      
      ownacquiror <- unique(ownacquiror)
      rm(own)
      
      
      ### PREMISSE: the shareholders are already arranged by direct %
      ### key: {dealnumber,targetbvdidnumber,acquirorbvdidnumber}
      ownacquiror$key <- NA
      for (i in 1:nrow(ownacquiror)) {
         if (is.na(ownacquiror$targetbvdidnumber[i])) {
            a <- "_"
         } else {
            a <- ownacquiror$targetbvdidnumber[i]
         }
      
         if (is.na(ownacquiror$acquirorbvdidnumber[i])) {
            b <- "_"
         } else {
            b <- ownacquiror$acquirorbvdidnumber[i]
         }
         
         ownacquiror$key[i] <- str_c(ownacquiror$dealnumber[i],a,b)
         rm(a,b)
      } ; rm(i)
      owntarget$key <- NA
      for (i in 1:nrow(owntarget)) {
         if (is.na(owntarget$targetbvdidnumber[i])) {
            a <- "_"
         } else {
            a <- owntarget$targetbvdidnumber[i]
         }
         
         if (is.na(owntarget$acquirorbvdidnumber[i])) {
            b <- "_"
         } else {
            b <- owntarget$acquirorbvdidnumber[i]
         }
         
         owntarget$key[i] <- str_c(owntarget$dealnumber[i],a,b)
         rm(a,b)
      } ; rm(i)
      
      
      ### for ACQUIRORS ###
      acquiror <- NULL
      for (i in unique(ownacquiror$key)) { #filter targets
         temp <- filter(ownacquiror, key == i)[1:3,]
         temp$order <- c("first","second","third")
      
         ###
         variablespread <- "acquirorshareholdersname"
         spreadtemp <- spread(data = select(temp, order, acquirorshareholdersname),
                              key = order,
                              value = acquirorshareholdersname,
                              fill = NA)
         colnames(spreadtemp) <- c(str_c(variablespread,"_","first"),
                                   str_c(variablespread,"_","second"),
                                   str_c(variablespread,"_","third"))
         
         ###
         variablespread <- "acquirorshareholdersbvdnumber"
         spreadtemp2 <- spread(data = select(temp, order, acquirorshareholdersbvdnumber),
                              key = order,
                              value = acquirorshareholdersbvdnumber,
                              fill = NA)
         colnames(spreadtemp2) <- c(str_c(variablespread,"_","first"),
                                   str_c(variablespread,"_","second"),
                                   str_c(variablespread,"_","third"))
         spreadtemp <- bind_cols(spreadtemp,spreadtemp2)
         
         ###
         variablespread <- "acquirorshareholderstype"
         spreadtemp2 <- spread(data = select(temp, order, acquirorshareholderstype),
                               key = order,
                               value = acquirorshareholderstype,
                               fill = NA)
         colnames(spreadtemp2) <- c(str_c(variablespread,"_","first"),
                                    str_c(variablespread,"_","second"),
                                    str_c(variablespread,"_","third"))
         spreadtemp <- bind_cols(spreadtemp,spreadtemp2)
      
         
         ###
         variablespread <- "acquirorshareholdersdirect"
         spreadtemp2 <- spread(data = select(temp, order, acquirorshareholdersdirect),
                               key = order,
                               value = acquirorshareholdersdirect,
                               fill = NA)
         colnames(spreadtemp2) <- c(str_c(variablespread,"_","first"),
                                    str_c(variablespread,"_","second"),
                                    str_c(variablespread,"_","third"))
         spreadtemp <- bind_cols(spreadtemp,spreadtemp2)
         rm(spreadtemp2,variablespread)
         spreadtemp$key <- i
         acquiror <- bind_rows(acquiror, spreadtemp)
         rm(spreadtemp,temp)
      } ; rm(i)
      
      ownacquiror <- unique(select(ownacquiror,
                              key,
                              dealnumber,
                              acquirorname,
                              acquirorbvdidnumber,
                              acquirorcountrycode,
                              acquirorregionwithinacountry,
                              acquirorprimarynaics2017code))
      
      ### CHECK one acquiror per key ##
      if (!all(table(ownacquiror$key) == 1)) {
         print("Error in Acquiror key, more than 1 Acquiror per deal")
         table(ownacquiror$key)[table(ownacquiror$key) != 1]
         break()
      }
      ### Join columns spread
      ownacquiror <- left_join(ownacquiror,
                               acquiror,
                               by = "key")
      rm(acquiror)
      
      ### for TARGETS ###
      target <- NULL
      for (i in unique(owntarget$key)) { #filter targets
         temp <- filter(owntarget, key == i)[1:3,]
         temp$order <- c("first","second","third")
         
         ###
         variablespread <- "targetshareholdersname"
         spreadtemp <- spread(data = select(temp, order, targetshareholdersname),
                              key = order,
                              value = targetshareholdersname,
                              fill = NA)
         colnames(spreadtemp) <- c(str_c(variablespread,"_","first"),
                                   str_c(variablespread,"_","second"),
                                   str_c(variablespread,"_","third"))
         
         ###
         variablespread <- "targetshareholdersbvdnumber"
         spreadtemp2 <- spread(data = select(temp, order, targetshareholdersbvdnumber),
                               key = order,
                               value = targetshareholdersbvdnumber,
                               fill = NA)
         colnames(spreadtemp2) <- c(str_c(variablespread,"_","first"),
                                    str_c(variablespread,"_","second"),
                                    str_c(variablespread,"_","third"))
         spreadtemp <- bind_cols(spreadtemp,spreadtemp2)
         
         ###
         variablespread <- "targetshareholderstype"
         spreadtemp2 <- spread(data = select(temp, order, targetshareholderstype),
                               key = order,
                               value = targetshareholderstype,
                               fill = NA)
         colnames(spreadtemp2) <- c(str_c(variablespread,"_","first"),
                                    str_c(variablespread,"_","second"),
                                    str_c(variablespread,"_","third"))
         spreadtemp <- bind_cols(spreadtemp,spreadtemp2)
         
         
         ###
         variablespread <- "targetshareholdersdirect"
         spreadtemp2 <- spread(data = select(temp, order, targetshareholdersdirect),
                               key = order,
                               value = targetshareholdersdirect,
                               fill = NA)
         colnames(spreadtemp2) <- c(str_c(variablespread,"_","first"),
                                    str_c(variablespread,"_","second"),
                                    str_c(variablespread,"_","third"))
         spreadtemp <- bind_cols(spreadtemp,spreadtemp2)
         rm(spreadtemp2,variablespread)
         spreadtemp$key <- i
         target <- bind_rows(target, spreadtemp)
         rm(spreadtemp,temp)
      } ; rm(i)
      
      owntarget <- unique(select(owntarget,
                                 key,
                                 dealnumber,
                                 targetname,
                                 targetbvdidnumber,
                                 targetcountrycode,
                                 targetregionwithinacountry,
                                 targetprimarynaics2017code))
      
      ### CHECK one target per key ##
      if (!all(table(owntarget$key) == 1)) {
         print("Error in target key, more than 1 target per deal")
         table(owntarget$key)[table(owntarget$key) != 1]
         break()
      }
      ### Join columns spread
      owntarget <- left_join(owntarget,
                               target,
                               by = "key")
      rm(target)
      
      
      
# Join Tables --------------------------------------------------------
      ## deal filter for non NAs in Target BVD and Acquiror BVD
      deal <- filter(deal, !is.na(targetbvdid))
      deal <- filter(deal, !is.na(acquirorbvdidnumber))
      ## deal key: {dealnumber,targetbvdid,acquirorbvdidnumber}
      deal$key <- NA
      for (i in 1:nrow(deal)) {
         if (is.na(deal$targetbvdid[i])) {
            a <- "_"
         } else {
            a <- deal$targetbvdid[i]
         }
         
         if (is.na(deal$acquirorbvdidnumber[i])) {
            b <- "_"
         } else {
            b <- deal$acquirorbvdidnumber[i]
         }
         
         deal$key[i] <- str_c(deal$dealnumber[i],a,b)
         rm(a,b)
      } ; rm(i)
      
      write.csv2(deal, "dealclean.csv", row.names = F)
      write.csv2(owntarget, "owntargetclean.csv", row.names = F)
      write.csv2(ownacquiror, "ownacquirorclean.csv", row.names = F)
      
      
      ## drop INVESTORS as Acquirors
      deal <- filter(deal, acquirorname != "INVESTORS")
      table(deal$key)[table(deal$key) > 1]
      
      
      ## join deal + own ##
      deal <- left_join(deal,
                        owntarget,
                        by = "key")
      deal <- left_join(deal,
                        ownacquiror,
                        by = "key")
      rm(owntarget, ownacquiror)
      
      write.csv2(deal, "dealtreat.csv")
   ## fin key: {dealnumber,targetbvdid,acquirorbvdidnumber}
   
   
   
# Corrections --------------------------------------------------------
deal <- read.csv2("dealtreat.csv",
                  header = T,
                  stringsAsFactors = F)
deal <- select(deal, -X)

#error: dealnumber: 1909563479
   filter(deal, dealnumber == "1909563479")
   

## Remove NA
   nrow(deal[is.na(deal[,"key"]),])
   deal <- deal[!is.na(deal[,"key"]),]

   rownames(deal) <- 1:nrow(deal)
   colnacheck <- c(
      "dealnumber.y",
      "targetname.y",
      "targetbvdidnumber",
      "targetcountrycode.y",
      "targetregionwithinacountry",
      "targetprimarynaics2017code",
      "targetshareholdersname_first",
      "targetshareholdersname_second",
      "targetshareholdersname_third",
      "targetshareholdersbvdnumber_first",
      "targetshareholdersbvdnumber_second",
      "targetshareholdersbvdnumber_third",
      "targetshareholderstype_first",
      "targetshareholderstype_second",
      "targetshareholderstype_third",
      "targetshareholdersdirect_first",
      "targetshareholdersdirect_second",
      "targetshareholdersdirect_third",
      "dealnumber",
      "acquirorname.y",
      "acquirorbvdidnumber.y",
      "acquirorcountrycode.y",
      "acquirorregionwithinacountry",
      "acquirorprimarynaics2017code",
      "acquirorshareholdersname_first",
      "acquirorshareholdersname_second",
      "acquirorshareholdersname_third",
      "acquirorshareholdersbvdnumber_first",
      "acquirorshareholdersbvdnumber_second",
      "acquirorshareholdersbvdnumber_third",
      "acquirorshareholderstype_first",
      "acquirorshareholderstype_second",
      "acquirorshareholderstype_third",
      "acquirorshareholdersdirect_first",
      "acquirorshareholdersdirect_second",
      "acquirorshareholdersdirect_third")

   cleaner <- NULL
   for (i in 1:nrow(deal)) {
      progress(i, max.value = nrow(deal), progress.bar = T)
      if(sum(is.na(deal[i,colnacheck])) == length(colnacheck)) {
         cleaner <- c(cleaner, i)
      }
   } ; rm(i)
   if (!is.null(cleaner)) {
      deal <- deal[-cleaner,]
   } ; rm(cleaner,colnacheck)
rownames(deal) <- 1:nrow(deal)


#1909473757
## Deal Number Check
deal[is.na(deal[,"dealnumber.x"]),]
deal[is.na(deal[,"dealnumber.y"]),]
deal[is.na(deal[,"dealnumber"]),]

all(deal[,"dealnumber.x"] == deal[,"dealnumber.y"])
all(deal[,"dealnumber"] == deal[,"dealnumber.y"])
all(deal[,"dealnumber.x"] == deal[,"dealnumber"])

deal <- select(deal, -dealnumber, -dealnumber.y)

## Names Check
# check the deal 1941113253 (BvD US290482208L) in deal the target name is EQUIDATE INC. and in own is FORGE GLOBAL INC.
# some inconsistences in names, like the use of dot (.) and abreviations are different in deal and own data bases
deal[(deal[,"targetname.x"] != deal[,"targetname.y"]),]
all(deal[,"targetname.x"] == deal[,"targetname.y"])

deal[(deal[,"acquirorname.x"] != deal[,"acquirorname.y"]),]
all(deal[,"acquirorname.x"] == deal[,"acquirorname.y"])

deal <- select(deal, -targetname.y, -acquirorname.y)

## Country Check
deal[(deal[,"targetcountrycode.x"] != deal[,"targetcountrycode.y"]),]
all(deal[,"targetcountrycode.x"] == deal[,"targetcountrycode.y"])

deal[(deal[,"acquirorcountrycode.x"] != deal[,"acquirorcountrycode.y"]),]
all(deal[,"acquirorcountrycode.x"] == deal[,"acquirorcountrycode.y"])

deal <- select(deal, -targetcountrycode.y, -acquirorcountrycode.y)


## BvD id Check
deal[(deal[,"targetbvdid"] != deal[,"targetbvdidnumber"]),]
all(deal[,"targetbvdid"] == deal[,"targetbvdidnumber"])

deal[(deal[,"acquirorbvdidnumber.x"] != deal[,"acquirorbvdidnumber.y"]),]
all(deal[,"acquirorbvdidnumber.x"] == deal[,"acquirorbvdidnumber.y"])

deal <- select(deal, -targetbvdid, -acquirorbvdidnumber.y)

deal <- select(deal,
               key,
               filename,
               dealnumber.x,
               dealstatus,
               dealtype,
               nativecurrency,
               dealvalueeur,
               dealvaluenative,
               dealequityvalueeur,
               dealequityvalueeurnative,
               daterumour,
               dateannounced,
               assumedcompletiondate,
               datecompleted,
               datelastdealstatus,
               targetname.x,
               targetbvdidnumber,
               targetcountrycode.x,
               targetregionwithinacountry,
               targetprimarynaics2017code,
               acquirorname.x,
               acquirorbvdidnumber.x,
               acquirorcountrycode.x,
               acquirorregionwithinacountry,
               acquirorprimarynaics2017code,
               initialstake,
               finalstake,
               initialstake_est,
               finalstake_est,
               stakevariation_est,
               targetshareholdersname_first,
               targetshareholdersname_second,
               targetshareholdersname_third,
               targetshareholdersbvdnumber_first,
               targetshareholdersbvdnumber_second,
               targetshareholdersbvdnumber_third,
               targetshareholderstype_first,
               targetshareholderstype_second,
               targetshareholderstype_third,
               targetshareholdersdirect_first,
               targetshareholdersdirect_second,
               targetshareholdersdirect_third,
               acquirorshareholdersname_first,
               acquirorshareholdersname_second,
               acquirorshareholdersname_third,
               acquirorshareholdersbvdnumber_first,
               acquirorshareholdersbvdnumber_second,
               acquirorshareholdersbvdnumber_third,
               acquirorshareholderstype_first,
               acquirorshareholderstype_second,
               acquirorshareholderstype_third,
               acquirorshareholdersdirect_first,
               acquirorshareholdersdirect_second,
               acquirorshareholdersdirect_third,
               )
colnames(deal) = c(
   "key",
   "filename",
   "dealnumber",
   "dealstatus",
   "dealtype",
   "nativecurrency",
   "dealvalueeur",
   "dealvaluenative",
   "dealequityvalueeur",
   "dealequityvalueeurnative",
   "daterumour",
   "dateannounced",
   "assumedcompletiondate",
   "datecompleted",
   "datelastdealstatus",
   "targetname",
   "targetbvdid",
   "targetcountrycode",
   "targetregion",
   "targetprimarynaics2017code",
   "acquirorname",
   "acquirorbvdid",
   "acquirorcountrycode",
   "acquirorregion",
   "acquirorprimarynaics2017code",
   "initialstake",
   "finalstake",
   "initialstake_est",
   "finalstake_est",
   "stakevariation_est",
   "targetshareholdersname_first",
   "targetshareholdersname_second",
   "targetshareholdersname_third",
   "targetshareholdersbvdnumber_first",
   "targetshareholdersbvdnumber_second",
   "targetshareholdersbvdnumber_third",
   "targetshareholderstype_first",
   "targetshareholderstype_second",
   "targetshareholderstype_third",
   "targetshareholdersdirect_first",
   "targetshareholdersdirect_second",
   "targetshareholdersdirect_third",
   "acquirorshareholdersname_first",
   "acquirorshareholdersname_second",
   "acquirorshareholdersname_third",
   "acquirorshareholdersbvdnumber_first",
   "acquirorshareholdersbvdnumber_second",
   "acquirorshareholdersbvdnumber_third",
   "acquirorshareholderstype_first",
   "acquirorshareholderstype_second",
   "acquirorshareholderstype_third",
   "acquirorshareholdersdirect_first",
   "acquirorshareholdersdirect_second",
   "acquirorshareholdersdirect_third")

write.csv2(x = deal,
           file = "dealtreat.csv",
           row.names = F,
           dec = ",")


# Clean Fin Data --------------------------------------------------------
fin <- read.csv2(file = unzip(zipfile, files = "findata.csv"),
                 header = T, 
                 stringsAsFactors = F,
                 colClasses = "character",
                 na.strings=c(""," ","NA","n.a."))

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
#fin <- dealsnareplace(fin)

#Remove NA and repeated rows
fin <- fin[rowSums(is.na(select(fin,-filename,-dealnumber))) != (ncol(fin)-2),]
fin <- unique(fin)

#Date format setup
fin <- dealsdate(fin)

