# Family Business US Merge and Acquisition (M&A) Project

# 3. Sample  
  
### Data Source  
* Database: Zephyr - M&A, IPO, private equity and venture capital deals and rumours  
* Data update: 25-jan-2019  
* Current deal status: Completed, Withdrawn  

### Restrictions and General Definitions  
**Period** -  10/1995 - 02/2019
  
**Region** -  US  
  
**Company Type** - only companies listed on the stock Exchange  
  
**Firm Control** - the control is defined with the level of equity participation (%). There are defined the thresholds to test robustness: 10%, 20%, 25% and 50%.   
  
### Variables Measures


#### [**H1.**] Ownership Similarity and Target Selection

**New Acquisition Occurrence** [*newao*]  
a variable that assumes values other than zero when the transaction status has been completed and the initial stake is equal to zero. Under these conditions the variable assumes the values:  
(1) if final stake > 50% (control);  
(2) if final stake = 50% (joint venture);  
(0) otherwise (minority aquisitions);  
  
In cases that the initial stake and final stake are *'Unknow %'* the levels are measured with the variable *dealtypes*. And a dummy *newao_origin* are created for control the origin of the measurement. It assumes value 0 if *newao* are obtained from *initialstake* and 1 from *dealtypes*.  
  
  *Questions*:  
  - Does *USDealsFin.'Target status'* have influence?  
  *{Active, Active (dormant), Active (insolvency proceedings), Bankruptcy, Dissolved, Dissolved (merger or take-over), In liquidation, Inactive (no precision)}*  
  
  
**Ownership Correspondence** [*owncorresp*]  
<span style="color:red">insuficient information about the type of ownership (family, foreign multinational, etc.)</span>  
  
  
**Ownership Commitment Similarity** [*owncommit*]   
  
[owncommit_score]  
<span style="color:red">insuficient information about the type of ownership (family, foreign multinational, etc.)</span>  
  
  
**Family Involvement Similarity** [*familysimilarity*]  
<span style="color:red">insuficient information about the type of ownership (family, foreign multinational, etc.)</span>  
  
  
**Geographical similarity** [*state*]  
Dummy variable that assumes value (1) if the companies are from the same state and (0) otherwise.
States are obtained from USOWN.xlsx, variables: *targetregion* and *acquirorregion*  
  
  
**Relative performance** [*roaperformance*]  
To access the ROA from target and acquiror firms we use variables from USFIN.xlsx, for net profits: *target_netprofit_eur_year1* and *acquiror_netprofit_eur_year1*; and for total assets: *target_totalassets_eur_year1* and *acquiror_totalassets_eur_year1*. Creating the variables *targetroa* and *acquirorroa*.  
Therefore, with these variables we measure the *roaperformance* variable.  
  
  
  *Questions*:  
  - what's the difference between *Net Profit* and *Profit After Taxes*?  
  - And the financial variables are in EURO currency, for indicadors from the same period there will not have impact because there is expected that values are converted by the same currency quotation.  
    
  
**Relative size** [*size*]  
To measure the *size* variable we use the variables *target_totalassets_eur_year1* and *acquiror_totalassets_eur_year1* from USFIN.xlsx.  
  
  
**Business similarity** [*naicssimilarity*]  
To assign the values 3, 2 and 1 for the same 6, 4 and 2 NAICS digits between the target and acquiror firms we use the variables *target_naics2017_code* and *acquiror_naics2017_code* from USOWN.xlsx.  
  
    
**Similarity Ownership Concentration** [*ownconcentration*]  
<span style="color:red">insuficient information about the number of shareholders with more than 2% of shares</span>  
  
  
**Industry Concentration**  
https://www.census.gov/econ/concentration.html  
[*acquirorconcentration*]  
4-digit NAICS concentration of the 50 largest firms.  
[*targetconcentration*]  
4-digit NAICS concentration of the 50 largest firms.  
  
  
  *Questions:*
  - both of business similarity and industry concentration variables are measured with the principal activities of the firms, maybe some aditional results could be achieve if compare the firms participation in other activities. Could be measure with the similarity and concentration of the principal activity of the target firm (or acquire) with the secondary, terciary of the acquire firm (or target).  
    
  
**Cash Slack** [*cashslack*]  
Measured as the ration of target ebitda by acquirer ebitda using the variables *acquiror_ebitda_eur_year1* and *target_ebitda_eur_year1* from USFIN.xlsx.  
  
  
#### [**H2.**] New Deals and Performance  
  
**New Deal Occurrence** [*newdo*]  
Variable that assumes values other than zero when the transaction status has been completed and the initial stake is greater than zero. Under these conditions the variable assumes the values:  
(1) if final stake > 50% (control);  
(2) if final stake = 50% (joint venture);  
(0) otherwise (minority aquisitions);  
  
In cases that the initial stake and final stake are *'Unknow %'* the levels are measured with the variable *dealtypes*. And a dummy *newdo_origin* are created for control the origin of the measurement. It assumes value 0 if *newdo* are obtained from *initialstake* and 1 from *dealtypes*.  
  
  
  
#### Appendix A - Target Data Base    
An example of the database to be achieved:  
  
newao | newao_origin | owncorresp | owncommit | familysimilarity | state | roaperformance | size | naicssimilarity | acquirorconcentration | targetconcentration | acquiror_ebitda_eur_year1 | target_ebitda_eur_year1 | cashslack | newdo | newdo_origin  
:- | :- | :- | :- | :- | :- | :- | :- | :- | :- | :- | :- | :- | :- | :- | :- | :- | :-  
0 | 0 | NA | NA | NA | 1 | 0.42 | 0.23 | 1 | 0.70 | 0.10 | 100000 | 56000 | 2.3 | 0 | 1  
1 | 1 | NA | NA | NA | 1 | 0.02 | 0.05 | 2 | 0.23 | 0.15 | 236000 | 99000 | 0.4 | 1 | 0  
2 | 0 | NA | NA | NA | 0 | 0.11 | 0.56 | 3 | 0.40 | 0.33 | 678000 | 74000 | 4.8 | 2 | 1  
  
  
#### Appendix B - Data Dictionary    

Variable | Origin | Description  
:- | :- | :-  
dealnumber | USDeals.xlsx | -  
targetcountrycode | USOWN.xlsx | used to filter US companies  
acquirorcountrycode | USOWN.xlsx | used to filter US companies  
initialstake | USDeals.xlsx | -  
finalstake | USDeals.xlsx | -  
dealtype | USDeals.xlsx | -  
newao | for *initialstake* = 0 then *finalstake*, or *dealtype* | (1) control for *finalstake* > 50% (2) joint venture for *finalstake* = 50% (0) minority for *finalstake* < 50%  
newao_origin | *initialstake* and *dealtype* | (0) if newao from *initialstake* (1) if from *dealtypes*  
targetregion | USOWN.xlsx | state within a country  
acquirorregion | USOWN.xlsx | state within a country  
state | *targetregion* = *acquirorregion* | (1) similar state (0) otherwise  
target_netprofit_eur_year1 | USFIN.xlsx | -  
target_totalassets_eur_year1 | USFIN.xlsx | -  
acquiror_netprofit_eur_year1 | USFIN.xlsx | -  
acquiror_totalassets_eur_year1 | USFIN.xlsx | -  
targetroa | $\frac{targetnetprofiteuryear1}{targettotalassetseuryear1}$ | Target Return on Assets  
acquirorroa | $\frac{acquirornetprofiteuryear1}{acquirortotalassetseuryear1}$ | Acquiror Return on Assets  
roaperformance | $\frac{|targetroa - acquirorroa|}{|targetroa + acquirorroa|}$ | Relative ROA performance in absolute differences  
size | $\frac{|targettotalassetseuryear1 - acquirortotalassetseuryear1|}{|targettotalassetseuryear1 + acquirortotalassetseuryear1|}$ | Relative total assets between target and acquiror in absolute differences  
target_naics2017_code | USOWN.xlsx | -  
acquiror_naics2017_code | USOWN.xlsx | -  
naicssimilarity | *target_naics2017_code* = *acquiror_naics2017_code* | The values assigned are (3) for 6-digits equality (2) for 4-digits equality (1) for 2-digits equality (0) otherwise  
acquirorconcentration  | US Census Bureau - Fact Finder | 4-digit NAICS, 50 largest firms, from 2012  
targetconcentration | US Census Bureau - Fact Finder | 4-digit NAICS, 50 largest firms, from 2012  
acquiror_ebitda_eur_year1 | USFIN.xlsx | -   
target_ebitda_eur_year1 | USFIN.xlsx | -   
cashslack | $\frac{targetebitdaeuryear1}{acquirorebitdaeuryear1}$ | ratio of cash between target and acquiror  
newdo | for *initialstake* > 0 then *finalstake*, or *dealtype* | (1) control for *finalstake* > 50% (2) joint venture for *finalstake* = 50% (0) minority for *finalstake* < 50%  
newdo_origin | *initialstake* and *dealtype* | (0) if newdo from *initialstake* (1) if from *dealtypes*  


#### Appendix C - Data Dictionary - Rename variables from raw data    


- **USDeals data**  

Original Variable Name | New Variable Name  
:- | :-  
...1 | dborder  
Deal Number | dealnumber  
Deal value th EUR...3 | dealvalueeur  
Deal value (Native currency) th LCU | dealvaluenative
Deal equity value th EUR | dealequityvalueeur
Deal equity value (Native currency) th LCU | dealequityvalueeurnative
Deal enterprise value th EUR | dealenterprisevalueeur
Deal enterprise value (Native currency) th LCU | dealenterprisevaluenative
Deal modelled enterprise value th EUR | dealmodelledenterprisevalueeur
Deal modelled enterprise value (Native currency) th LCU | dealmodelledenterprisevaluenative
Deal total target value th EUR | dealtotaltargetvalueeur
Deal total target value (Native currency) th LCU | dealtotaltargetvaluenative
Modelled Fee Income th EUR | modelledfeeincometheur
As Reported Fee Income th EUR | asreportedfeeincometheur
Initial stake (%) | initialstake
Acquired stake (%) | acquired stake
Final stake (%) | finalstake
IRR (%) | irr
Native currency | nativecurrency
Deal type...20 | dealtype
Deal sub-type | dealsub-type
Deal financing | dealfinancing
Deal method of payment | dealmethodofpayment
Deal method of payment value th EUR | dealmethodofpaymentvaluetheur
Deal status...25 | dealstatus
Rumour date | daterumour
Announced date | dateannounced
Expected completion date | expectedcompletiondate
Assumed completion date | assumedcompletiondate
Completed date | datecompleted
Postponed date | postponeddate
Withdrawn  date | withdrawndate
Last deal status date | datelastdealstatus
Last deal value, offer price, bid premium update date | lastdealvalueofferpricebidpremiumupdatedate
Last deal status update date | lastdealstatusupdatedate
Last % of stake update date | lastofstakeupdatedate
Last acquiror, target, vendor update date | lastacquirortargetvendorupdatedate
Last advisor update date | lastadvisorupdatedate
Last deal comment, rationale update date | lastdealcommentrationaleupdatedate
Last update | datelastupdate
Deal headline | dealheadline
Deal type...42 | dealtypeb
Deal status...43 | dealstatusb
Deal value th EUR...44 | dealvalueeurb
Target name | targetname
Target country code | targetcountrycode
Target business description(s) | targetbusinessdescription
Target BvD ID number | targetbvdid
Acquiror name | acquirorname
Acquiror country code | acquirorcountrycode
Acquiror business description(s) | acquirorbusinessdescription
Acquiror BvD ID number | acquirorbvdidnumber
Group acquiror name | groupacquirorname
Group acquiror country code | groupacquirorcountrycode
Group acquiror business description(s) | groupacquirorbusinessdescription
Group acquiror BvD ID number | groupacquirorbvdid
Vendor name | vendorname
Vendor country code | vendorcountrycode
Vendor business description(s) | vendorbusinessdescriptions
Vendor BvD ID number | vendorbvdid
Group vendor name | groupvendorname
Group vendor country code | groupvendorcountrycode
Group vendor business description(s) | groupvendorbusinessdescription
Group vendor BvD ID number | groupvendorbvdid
Regulatory body name | regulatorybodyname
Regulatory body country | regulatorybodycountry
Type of deal opportunity | typeofdealopportunity
Pre-deal target operating revenue/turnover th EUR Quarter - 1 | pre-dealtargetoperatingrevenueturnovertheurquarter-1
Pre-deal target operating revenue/turnover th EUR Quarter - 2 | pre-dealtargetoperatingrevenueturnovertheurquarter-2
Pre-deal target operating revenue/turnover th EUR Quarter - 3 | pre-dealtargetoperatingrevenueturnovertheurquarter-3
Pre-deal target EBITDA th EUR Quarter - 1 | pre-dealtargetebitdatheurquarter-1
Pre-deal target EBITDA th EUR Quarter - 2 | pre-dealtargetebitdatheurquarter-2
Pre-deal target EBITDA th EUR Quarter - 3 | pre-dealtargetebitdatheurquarter-3
Pre-deal target EBIT th EUR Quarter - 1 | pre-dealtargetebittheurquarter-1
Pre-deal target EBIT th EUR Quarter - 2 | pre-dealtargetebittheurquarter-2
Pre-deal target EBIT th EUR Quarter - 3 | pre-dealtargetebittheurquarter-3
Pre-deal target profit before tax th EUR Quarter - 1 | pre-dealtargetprofitbeforetaxtheurquarter-1
Pre-deal target profit before tax th EUR Quarter - 2 | pre-dealtargetprofitbeforetaxtheurquarter-2
Pre-deal target profit before tax th EUR Quarter - 3 | pre-dealtargetprofitbeforetaxtheurquarter-3
Pre-deal target profit after tax th EUR Quarter - 1 | pre-dealtargetprofitaftertaxtheurquarter-1
Pre-deal target profit after tax th EUR Quarter - 2 | pre-dealtargetprofitaftertaxtheurquarter-2
Pre-deal target profit after tax th EUR Quarter - 3 | pre-dealtargetprofitaftertaxtheurquarter-3
Pre-deal target net profit th EUR Quarter - 1 | pre-dealtargetnetprofittheurquarter-1
Pre-deal target net profit th EUR Quarter - 2 | pre-dealtargetnetprofittheurquarter-2
Pre-deal target net profit th EUR Quarter - 3 | pre-dealtargetnetprofittheurquarter-3
Pre-deal target total assets th EUR Quarter - 1 | pre-dealtargettotalassetstheurquarter-1
Pre-deal target total assets th EUR Quarter - 2 | pre-dealtargettotalassetstheurquarter-2
Pre-deal target total assets th EUR Quarter - 3 | pre-dealtargettotalassetstheurquarter-3
Pre-deal target net assets th EUR Quarter - 1 | pre-dealtargetnetassetstheurquarter-1
Pre-deal target net assets th EUR Quarter - 2 | pre-dealtargetnetassetstheurquarter-2
Pre-deal target net assets th EUR Quarter - 3 | pre-dealtargetnetassetstheurquarter-3
Pre-deal target shareholders funds th EUR Quarter - 1 | pre-dealtargetshareholdersfundstheurquarter-1
Pre-deal target shareholders funds th EUR Quarter - 2 | pre-dealtargetshareholdersfundstheurquarter-2
Pre-deal target shareholders funds th EUR Quarter - 3 | pre-dealtargetshareholdersfundstheurquarter-3
Pre-deal target market capitalisation (Last available year) th EUR | pre-dealtargetmarketcapitalisationlastavailableyeartheur
Pre-deal acquiror operating revenue/turnover th EUR Last avail. yr | pre-dealacquiroroperatingrevenueturnovertheurlastavailyr
Pre-deal acquiror operating revenue/turnover th EUR Quarter - 1 | pre-dealacquiroroperatingrevenueturnovertheurquarter-1
Pre-deal acquiror operating revenue/turnover th EUR Quarter - 2 | pre-dealacquiroroperatingrevenueturnovertheurquarter-2
Pre-deal acquiror operating revenue/turnover th EUR Quarter - 3 | pre-dealacquiroroperatingrevenueturnovertheurquarter-3
Pre-deal acquiror EBITDA th EUR Last avail. yr | pre-dealacquirorebitdatheurlastavailyr
Pre-deal acquiror EBITDA th EUR Quarter - 1 | pre-dealacquirorebitdatheurquarter-1
Pre-deal acquiror EBITDA th EUR Quarter - 2 | pre-dealacquirorebitdatheurquarter-2
Pre-deal acquiror EBITDA th EUR Quarter - 3 | pre-dealacquirorebitdatheurquarter-3
Pre-deal acquiror EBIT th EUR Last avail. yr | pre-dealacquirorebittheurlastavailyr
Pre-deal acquiror EBIT th EUR Quarter - 1 | pre-dealacquirorebittheurquarter-1
Pre-deal acquiror EBIT th EUR Quarter - 2 | pre-dealacquirorebittheurquarter-2
Pre-deal acquiror EBIT th EUR Quarter - 3 | pre-dealacquirorebittheurquarter-3
Pre-deal acquiror profit before tax th EUR Last avail. yr | pre-dealacquirorprofitbeforetaxtheurlastavailyr
Pre-deal acquiror profit before tax th EUR Quarter - 1 | pre-dealacquirorprofitbeforetaxtheurquarter-1
Pre-deal acquiror profit before tax th EUR Quarter - 2 | pre-dealacquirorprofitbeforetaxtheurquarter-2
Pre-deal acquiror profit before tax th EUR Quarter - 3 | pre-dealacquirorprofitbeforetaxtheurquarter-3
Pre-deal acquiror profit after tax th EUR Last avail. yr | pre-dealacquirorprofitaftertaxtheurlastavailyr
Pre-deal acquiror profit after tax th EUR Quarter - 1 | pre-dealacquirorprofitaftertaxtheurquarter-1
Pre-deal acquiror profit after tax th EUR Quarter - 2 | pre-dealacquirorprofitaftertaxtheurquarter-2
Pre-deal acquiror profit after tax th EUR Quarter - 3 | pre-dealacquirorprofitaftertaxtheurquarter-3
Pre-deal acquiror net profit th EUR Last avail. yr | pre-dealacquirornetprofittheurlastavailyr
Pre-deal acquiror net profit th EUR Quarter - 1 | pre-dealacquirornetprofittheurquarter-1
Pre-deal acquiror net profit th EUR Quarter - 2 | pre-dealacquirornetprofittheurquarter-2
Pre-deal acquiror net profit th EUR Quarter - 3 | pre-dealacquirornetprofittheurquarter-3
Pre-deal acquiror total assets th EUR Last avail. yr | pre-dealacquirortotalassetstheurlastavailyr
Pre-deal acquiror total assets th EUR Quarter - 1 | pre-dealacquirortotalassetstheurquarter-1
Pre-deal acquiror total assets th EUR Quarter - 2 | pre-dealacquirortotalassetstheurquarter-2
Pre-deal acquiror total assets th EUR Quarter - 3 | pre-dealacquirortotalassetstheurquarter-3
Pre-deal acquiror net assets th EUR Last avail. yr | pre-dealacquirornetassetstheurlastavailyr
Pre-deal acquiror net assets th EUR Quarter - 1 | pre-dealacquirornetassetstheurquarter-1
Pre-deal acquiror net assets th EUR Quarter - 2 | pre-dealacquirornetassetstheurquarter-2
Pre-deal acquiror net assets th EUR Quarter - 3 | pre-dealacquirornetassetstheurquarter-3
Pre-deal acquiror shareholders funds th EUR Last avail. yr | pre-dealacquirorshareholdersfundstheurlastavailyr
Pre-deal acquiror shareholders funds th EUR Quarter - 1 | pre-dealacquirorshareholdersfundstheurquarter-1
Pre-deal acquiror shareholders funds th EUR Quarter - 2 | pre-dealacquirorshareholdersfundstheurquarter-2
Pre-deal acquiror shareholders funds th EUR Quarter - 3 | pre-dealacquirorshareholdersfundstheurquarter-3
Pre-deal acquiror market capitalisation (Last available year) th EUR | pre-dealacquirormarketcapitalisationlastavailableyeartheur
Post-deal target operating revenue/turnover th EUR Quarter + 1 | post-dealtargetoperatingrevenueturnovertheurquarter1
Post-deal target operating revenue/turnover th EUR Quarter + 2 | post-dealtargetoperatingrevenueturnovertheurquarter2
Post-deal target operating revenue/turnover th EUR Quarter + 3 | post-dealtargetoperatingrevenueturnovertheurquarter3
Post-deal target EBITDA th EUR Quarter + 1 | post-dealtargetebitdatheurquarter1
Post-deal target EBITDA th EUR Quarter + 2 | post-dealtargetebitdatheurquarter2
Post-deal target EBITDA th EUR Quarter + 3 | post-dealtargetebitdatheurquarter3
Post-deal target EBIT th EUR Quarter + 1 | post-dealtargetebittheurquarter1
Post-deal target EBIT th EUR Quarter + 2 | post-dealtargetebittheurquarter2
Post-deal target EBIT th EUR Quarter + 3 | post-dealtargetebittheurquarter3
Post-deal target profit before tax th EUR Quarter + 1 | post-dealtargetprofitbeforetaxtheurquarter1
Post-deal target profit before tax th EUR Quarter + 2 | post-dealtargetprofitbeforetaxtheurquarter2
Post-deal target profit before tax th EUR Quarter + 3 | post-dealtargetprofitbeforetaxtheurquarter3
Post-deal target profit after tax th EUR Quarter + 1 | post-dealtargetprofitaftertaxtheurquarter1
Post-deal target profit after tax th EUR Quarter + 2 | post-dealtargetprofitaftertaxtheurquarter2
Post-deal target profit after tax th EUR Quarter + 3 | post-dealtargetprofitaftertaxtheurquarter3
Post-deal target net profit th EUR Quarter + 1 | post-dealtargetnetprofittheurquarter1
Post-deal target net profit th EUR Quarter + 2 | post-dealtargetnetprofittheurquarter2
Post-deal target net profit th EUR Quarter + 3 | post-dealtargetnetprofittheurquarter3
Post-deal target total assets th EUR Quarter + 1 | post-dealtargettotalassetstheurquarter1
Post-deal target total assets th EUR Quarter + 2 | post-dealtargettotalassetstheurquarter2
Post-deal target total assets th EUR Quarter + 3 | post-dealtargettotalassetstheurquarter3
Post-deal target net assets th EUR Quarter + 1 | post-dealtargetnetassetstheurquarter1
Post-deal target net assets th EUR Quarter + 2 | post-dealtargetnetassetstheurquarter2
Post-deal target net assets th EUR Quarter + 3 | post-dealtargetnetassetstheurquarter3
Post-deal target shareholder funds th EUR Quarter + 1 | post-dealtargetshareholderfundstheurquarter1
Post-deal target shareholder funds th EUR Quarter + 2 | post-dealtargetshareholderfundstheurquarter2
Post-deal target shareholder funds th EUR Quarter + 3 | post-dealtargetshareholderfundstheurquarter3
Post-deal target market capitalisation (First available year) th EUR | post-dealtargetmarketcapitalisationfirstavailableyeartheur
Post-deal acquiror operating revenue/turnover th EUR Quarter + 1 | post-dealacquiroroperatingrevenueturnovertheurquarter1
Post-deal acquiror operating revenue/turnover th EUR Quarter + 2 | post-dealacquiroroperatingrevenueturnovertheurquarter2
Post-deal acquiror operating revenue/turnover th EUR Quarter + 3 | post-dealacquiroroperatingrevenueturnovertheurquarter3
Post-deal acquiror EBITDA th EUR Quarter + 1 | post-dealacquirorebitdatheurquarter1
Post-deal acquiror EBITDA th EUR Quarter + 2 | post-dealacquirorebitdatheurquarter2
Post-deal acquiror EBITDA th EUR Quarter + 3 | post-dealacquirorebitdatheurquarter3
Post-deal acquiror EBIT th EUR Quarter + 1 | post-dealacquirorebittheurquarter1
Post-deal acquiror EBIT th EUR Quarter + 2 | post-dealacquirorebittheurquarter2
Post-deal acquiror EBIT th EUR Quarter + 3 | post-dealacquirorebittheurquarter3
Post-deal acquiror profit before tax th EUR Quarter + 1 | post-dealacquirorprofitbeforetaxtheurquarter1
Post-deal acquiror profit before tax th EUR Quarter + 2 | post-dealacquirorprofitbeforetaxtheurquarter2
Post-deal acquiror profit before tax th EUR Quarter + 3 | post-dealacquirorprofitbeforetaxtheurquarter3
Post-deal acquiror profit after tax th EUR Quarter + 1 | post-dealacquirorprofitaftertaxtheurquarter1
Post-deal acquiror profit after tax th EUR Quarter + 2 | post-dealacquirorprofitaftertaxtheurquarter2
Post-deal acquiror profit after tax th EUR Quarter + 3 | post-dealacquirorprofitaftertaxtheurquarter3
Post-deal acquiror net profit th EUR Quarter + 1 | post-dealacquirornetprofittheurquarter1
Post-deal acquiror net profit th EUR Quarter + 2 | post-dealacquirornetprofittheurquarter2
Post-deal acquiror net profit th EUR Quarter + 3 | post-dealacquirornetprofittheurquarter3
Post-deal acquiror total assets th EUR Quarter + 1 | post-dealacquirortotalassetstheurquarter1
Post-deal acquiror total assets th EUR Quarter + 2 | post-dealacquirortotalassetstheurquarter2
Post-deal acquiror total assets th EUR Quarter + 3 | post-dealacquirortotalassetstheurquarter3
Post-deal acquiror net assets th EUR Quarter + 1 | post-dealacquirornetassetstheurquarter1
Post-deal acquiror net assets th EUR Quarter + 2 | post-dealacquirornetassetstheurquarter2
Post-deal acquiror net assets th EUR Quarter + 3 | post-dealacquirornetassetstheurquarter3
Post-deal acquiror shareholder funds th EUR Quarter + 1 | post-dealacquirorshareholderfundstheurquarter1
Post-deal acquiror shareholder funds th EUR Quarter + 2 | post-dealacquirorshareholderfundstheurquarter2
Post-deal acquiror shareholder funds th EUR Quarter + 3 | post-dealacquirorshareholderfundstheurquarter3
Post-deal acquiror market capitalisation (First available year) th EUR | post-dealacquirormarketcapitalisationfirstavailableyeartheur
Target stock price 3 months prior to rumour EUR | targetstockprice3monthspriortorumoureur
Target stock price 3 months prior to announcement EUR | targetstockprice3monthspriortoannouncementeur
Target stock price prior to rumour EUR | targetstockpricepriortorumoureur
Target stock price prior to announcement EUR | targetstockpricepriortoannouncementeur
Target stock price at completion date EUR | targetstockpriceatcompletiondateeur
Target stock price after completion EUR | targetstockpriceaftercompletioneur
Target stock price 1 week after completion EUR | targetstockprice1weekaftercompletioneur
Target stock price 1 month after completion EUR | targetstockprice1monthaftercompletioneur
Acquiror stock price 3 months prior to rumour EUR | acquirorstockprice3monthspriortorumoureur
Acquiror stock price 3 months prior to announcement EUR | acquirorstockprice3monthspriortoannouncementeur
Acquiror stock price prior to rumour EUR | acquirorstockpricepriortorumoureur
Acquiror stock price prior to announcement EUR | acquirorstockpricepriortoannouncementeur
Acquiror stock price at completion date EUR | acquirorstockpriceatcompletiondateeur
Acquiror stock price after completion EUR | acquirorstockpriceaftercompletioneur
Acquiror stock price 1 week after completion EUR | acquirorstockprice1weekaftercompletioneur
Acquiror stock price 1 month after completion EUR | acquirorstockprice1monthaftercompletioneur
Category of source | categoryofsource
Source documentation | sourcedocumentation
filename | filename
  
  
- **USDealsFin data**  
  
  
Original Variable Name | New Variable Name  
:- | :-  
...1 | dborder  
Deal Number | dealnumber  
Target operating revenue/turnover th EUR Year - 1 | target_operatingrevenue_eur_year1
Target operating revenue/turnover th EUR Year - 2 | target_operatingrevenue_eur_year2
Target operating revenue/turnover th EUR Quarter - 1 | target_operatingrevenue_eur_quarter1
Target operating revenue/turnover th EUR Quarter - 2 | target_operatingrevenue_eur_quarter2
Target operating revenue/turnover th EUR Quarter - 3 | target_operatingrevenue_eur_quarter3
Target operating revenue/turnover th EUR Quarter - 4 | target_operatingrevenue_eur_quarter4
Target operating revenue/turnover th EUR Quarter - 5 | target_operatingrevenue_eur_quarter5
Target operating revenue/turnover th EUR Quarter - 6 | target_operatingrevenue_eur_quarter6
Target operating revenue/turnover th EUR Quarter - 7 | target_operatingrevenue_eur_quarter7
Target operating revenue/turnover th EUR Quarter - 8 | target_operatingrevenue_eur_quarter8
Target EBITDA th EUR Year - 1 | target_ebitda_eur_year1
Target EBITDA th EUR Year - 2 | target_ebitda_eur_year2
Target EBITDA th EUR Quarter - 1 | target_ebitda_eur_quarter1
Target EBITDA th EUR Quarter - 2 | target_ebitda_eur_quarter2
Target EBITDA th EUR Quarter - 3 | target_ebitda_eur_quarter3
Target EBITDA th EUR Quarter - 4 | target_ebitda_eur_quarter4
Target EBITDA th EUR Quarter - 5 | target_ebitda_eur_quarter5
Target EBITDA th EUR Quarter - 6 | target_ebitda_eur_quarter6
Target EBITDA th EUR Quarter - 7 | target_ebitda_eur_quarter7
Target EBITDA th EUR Quarter - 8 | target_ebitda_eur_quarter8
Target EBIT th EUR Year - 1 | target_ebit_eur_year1
Target EBIT th EUR Year - 2 | target_ebit_eur_year2
Target EBIT th EUR Quarter - 1 | target_ebit_eur_quarter1
Target EBIT th EUR Quarter - 2 | target_ebit_eur_quarter2
Target EBIT th EUR Quarter - 3 | target_ebit_eur_quarter3
Target EBIT th EUR Quarter - 4 | target_ebit_eur_quarter4
Target EBIT th EUR Quarter - 5 | target_ebit_eur_quarter5
Target EBIT th EUR Quarter - 6 | target_ebit_eur_quarter6
Target EBIT th EUR Quarter - 7 | target_ebit_eur_quarter7
Target EBIT th EUR Quarter - 8 | target_ebit_eur_quarter8
Target profit before tax th EUR Year - 1 | target_profitbeforetax_eur_year1
Target profit before tax th EUR Year - 2 | target_profitbeforetax_eur_year2
Target profit before tax th EUR Quarter - 1 | target_profitbeforetax_eur_quarter1
Target profit before tax th EUR Quarter - 2 | target_profitbeforetax_eur_quarter2
Target profit before tax th EUR Quarter - 3 | target_profitbeforetax_eur_quarter3
Target profit before tax th EUR Quarter - 4 | target_profitbeforetax_eur_quarter4
Target profit before tax th EUR Quarter - 5 | target_profitbeforetax_eur_quarter5
Target profit before tax th EUR Quarter - 6 | target_profitbeforetax_eur_quarter6
Target profit before tax th EUR Quarter - 7 | target_profitbeforetax_eur_quarter7
Target profit before tax th EUR Quarter - 8 | target_profitbeforetax_eur_quarter8
Target profit after tax th EUR Year - 1 | target_profitaftertax_eur_year1
Target profit after tax th EUR Year - 2 | target_profitaftertax_eur_year2
Target profit after tax th EUR Quarter - 1 | target_profitaftertax_eur_quarter1
Target profit after tax th EUR Quarter - 2 | target_profitaftertax_eur_quarter2
Target profit after tax th EUR Quarter - 3 | target_profitaftertax_eur_quarter3
Target profit after tax th EUR Quarter - 4 | target_profitaftertax_eur_quarter4
Target profit after tax th EUR Quarter - 5 | target_profitaftertax_eur_quarter5
Target profit after tax th EUR Quarter - 6 | target_profitaftertax_eur_quarter6
Target profit after tax th EUR Quarter - 7 | target_profitaftertax_eur_quarter7
Target profit after tax th EUR Quarter - 8 | target_profitaftertax_eur_quarter8
Target net profit th EUR Year - 1 | target_netprofit_eur_year1
Target net profit th EUR Year - 2 | target_netprofit_eur_year2
Target net profit th EUR Quarter - 1 | target_netprofit_eur_quarter1
Target net profit th EUR Quarter - 2 | target_netprofit_eur_quarter2
Target net profit th EUR Quarter - 3 | target_netprofit_eur_quarter3
Target net profit th EUR Quarter - 4 | target_netprofit_eur_quarter4
Target net profit th EUR Quarter - 5 | target_netprofit_eur_quarter5
Target net profit th EUR Quarter - 6 | target_netprofit_eur_quarter6
Target net profit th EUR Quarter - 7 | target_netprofit_eur_quarter7
Target net profit th EUR Quarter - 8 | target_netprofit_eur_quarter8
Target total assets th EUR Year - 1 | target_totalassets_eur_year1
Target total assets th EUR Year - 2 | target_totalassets_eur_year2
Target total assets th EUR Quarter - 1 | target_totalassets_eur_quarter1
Target total assets th EUR Quarter - 2 | target_totalassets_eur_quarter2
Target total assets th EUR Quarter - 3 | target_totalassets_eur_quarter3
Target total assets th EUR Quarter - 4 | target_totalassets_eur_quarter4
Target total assets th EUR Quarter - 5 | target_totalassets_eur_quarter5
Target total assets th EUR Quarter - 6 | target_totalassets_eur_quarter6
Target total assets th EUR Quarter - 7 | target_totalassets_eur_quarter7
Target total assets th EUR Quarter - 8 | target_totalassets_eur_quarter8
Target net assets th EUR Year - 1 | target_netassets_eur_year1
Target net assets th EUR Year - 2 | target_netassets_eur_year2
Target net assets th EUR Quarter - 1 | target_netassets_eur_quarter1
Target net assets th EUR Quarter - 2 | target_netassets_eur_quarter2
Target net assets th EUR Quarter - 3 | target_netassets_eur_quarter3
Target net assets th EUR Quarter - 4 | target_netassets_eur_quarter4
Target net assets th EUR Quarter - 5 | target_netassets_eur_quarter5
Target net assets th EUR Quarter - 6 | target_netassets_eur_quarter6
Target net assets th EUR Quarter - 7 | target_netassets_eur_quarter7
Target net assets th EUR Quarter - 8 | target_netassets_eur_quarter8
Target shareholders funds th EUR Year - 1 | target_shareholdersfunds_eur_year1
Target shareholders funds th EUR Year - 2 | target_shareholdersfunds_eur_year2
Target shareholders funds th EUR Quarter - 1 | target_shareholdersfunds_eur_quarter1
Target shareholders funds th EUR Quarter - 2 | target_shareholdersfunds_eur_quarter2
Target shareholders funds th EUR Quarter - 3 | target_shareholdersfunds_eur_quarter3
Target shareholders funds th EUR Quarter - 4 | target_shareholdersfunds_eur_quarter4
Target shareholders funds th EUR Quarter - 5 | target_shareholdersfunds_eur_quarter5
Target shareholders funds th EUR Quarter - 6 | target_shareholdersfunds_eur_quarter6
Target shareholders funds th EUR Quarter - 7 | target_shareholdersfunds_eur_quarter7
Target shareholders funds th EUR Quarter - 8 | target_shareholdersfunds_eur_quarter8
Target market capitalisation th EUR Year - 1 | target_marketcapitalisation_eur_year1
Target market capitalisation th EUR Year - 2 | target_marketcapitalisation_eur_year2
Target number of employees Year - 1 | target_numberofemployees_year1
Target number of employees Year - 2 | target_numberofemployees_year2
Target number of employees Quarter - 1 | target_numberofemployees_quarter1
Target number of employees Quarter - 2 | target_numberofemployees_quarter2
Target number of employees Quarter - 3 | target_numberofemployees_quarter3
Target number of employees Quarter - 4 | target_numberofemployees_quarter4
Target number of employees Quarter - 5 | target_numberofemployees_quarter5
Target number of employees Quarter - 6 | target_numberofemployees_quarter6
Target number of employees Quarter - 7 | target_numberofemployees_quarter7
Target number of employees Quarter - 8 | target_numberofemployees_quarter8
Target enterprise value th EUR Year - 1 | target_enterprisevalue_eur_year1
Target enterprise value th EUR Year - 2 | target_enterprisevalue_eur_year2
Target enterprise value th EUR Quarter - 1 | target_enterprisevalue_eur_quarter1
Target enterprise value th EUR Quarter - 2 | target_enterprisevalue_eur_quarter2
Target enterprise value th EUR Quarter - 3 | target_enterprisevalue_eur_quarter3
Target enterprise value th EUR Quarter - 4 | target_enterprisevalue_eur_quarter4
Target enterprise value th EUR Quarter - 5 | target_enterprisevalue_eur_quarter5
Target enterprise value th EUR Quarter - 6 | target_enterprisevalue_eur_quarter6
Target enterprise value th EUR Quarter - 7 | target_enterprisevalue_eur_quarter7
Target enterprise value th EUR Quarter - 8 | target_enterprisevalue_eur_quarter8
Target earnings per share Year - 1 | target_earningspershare_year1
Target earnings per share Year - 2 | target_earningspershare_year2
Target cash flow per share Year - 1 | target_cashflowpershare_year1
Target cash flow per share Year - 2 | target_cashflowpershare_year2
Target dividend per share Year - 1 | target_dividendpershare_year1
Target dividend per share Year - 2 | target_dividendpershare_year2
Target book value per share Year - 1 | target_bookvaluepershare_year1
Target book value per share Year - 2 | target_bookvaluepershare_year2
Acquiror operating revenue/turnover th EUR Year - 1 | acquiror_operatingrevenue_eur_year1
Acquiror operating revenue/turnover th EUR Year - 2 | acquiror_operatingrevenue_eur_year2
Acquiror operating revenue/turnover th EUR Quarter - 1 | acquiror_operatingrevenue_eur_quarter1
Acquiror operating revenue/turnover th EUR Quarter - 2 | acquiror_operatingrevenue_eur_quarter2
Acquiror operating revenue/turnover th EUR Quarter - 3 | acquiror_operatingrevenue_eur_quarter3
Acquiror operating revenue/turnover th EUR Quarter - 4 | acquiror_operatingrevenue_eur_quarter4
Acquiror operating revenue/turnover th EUR Quarter - 5 | acquiror_operatingrevenue_eur_quarter5
Acquiror operating revenue/turnover th EUR Quarter - 6 | acquiror_operatingrevenue_eur_quarter6
Acquiror operating revenue/turnover th EUR Quarter - 7 | acquiror_operatingrevenue_eur_quarter7
Acquiror operating revenue/turnover th EUR Quarter - 8 | acquiror_operatingrevenue_eur_quarter8
Acquiror EBITDA th EUR Year - 1 | acquiror_ebitda_eur_year1
Acquiror EBITDA th EUR Year - 2 | acquiror_ebitda_eur_year2
Acquiror EBITDA th EUR Quarter - 1 | acquiror_ebitda_eur_quarter1
Acquiror EBITDA th EUR Quarter - 2 | acquiror_ebitda_eur_quarter2
Acquiror EBITDA th EUR Quarter - 3 | acquiror_ebitda_eur_quarter3
Acquiror EBITDA th EUR Quarter - 4 | acquiror_ebitda_eur_quarter4
Acquiror EBITDA th EUR Quarter - 5 | acquiror_ebitda_eur_quarter5
Acquiror EBITDA th EUR Quarter - 6 | acquiror_ebitda_eur_quarter6
Acquiror EBITDA th EUR Quarter - 7 | acquiror_ebitda_eur_quarter7
Acquiror EBITDA th EUR Quarter - 8 | acquiror_ebitda_eur_quarter8
Acquiror EBIT th EUR Year - 1 | acquiror_ebit_eur_year1
Acquiror EBIT th EUR Year - 2 | acquiror_ebit_eur_year2
Acquiror EBIT th EUR Quarter - 1 | acquiror_ebit_eur_quarter1
Acquiror EBIT th EUR Quarter - 2 | acquiror_ebit_eur_quarter2
Acquiror EBIT th EUR Quarter - 3 | acquiror_ebit_eur_quarter3
Acquiror EBIT th EUR Quarter - 4 | acquiror_ebit_eur_quarter4
Acquiror EBIT th EUR Quarter - 5 | acquiror_ebit_eur_quarter5
Acquiror EBIT th EUR Quarter - 6 | acquiror_ebit_eur_quarter6
Acquiror EBIT th EUR Quarter - 7 | acquiror_ebit_eur_quarter7
Acquiror EBIT th EUR Quarter - 8 | acquiror_ebit_eur_quarter8
Acquiror profit before tax th EUR Year - 1 | acquiror_profitbeforetax_eur_year1
Acquiror profit before tax th EUR Year - 2 | acquiror_profitbeforetax_eur_year1
Acquiror profit before tax th EUR Quarter - 1 | acquiror_profitbeforetax_eur_quarter1
Acquiror profit before tax th EUR Quarter - 2 | acquiror_profitbeforetax_eur_quarter2
Acquiror profit before tax th EUR Quarter - 3 | acquiror_profitbeforetax_eur_quarter3
Acquiror profit before tax th EUR Quarter - 4 | acquiror_profitbeforetax_eur_quarter4
Acquiror profit before tax th EUR Quarter - 5 | acquiror_profitbeforetax_eur_quarter5
Acquiror profit before tax th EUR Quarter - 6 | acquiror_profitbeforetax_eur_quarter6
Acquiror profit before tax th EUR Quarter - 7 | acquiror_profitbeforetax_eur_quarter7
Acquiror profit before tax th EUR Quarter - 8 | acquiror_profitbeforetax_eur_quarter8
Acquiror profit after tax th EUR Year - 1 | acquiror_profitaftertax_eur_year1
Acquiror profit after tax th EUR Year - 2 | acquiror_profitaftertax_eur_year2
Acquiror profit after tax th EUR Quarter - 1 | acquiror_profitaftertax_eur_quarter1
Acquiror profit after tax th EUR Quarter - 2 | acquiror_profitaftertax_eur_quarter2
Acquiror profit after tax th EUR Quarter - 3 | acquiror_profitaftertax_eur_quarter3
Acquiror profit after tax th EUR Quarter - 4 | acquiror_profitaftertax_eur_quarter4
Acquiror profit after tax th EUR Quarter - 5 | acquiror_profitaftertax_eur_quarter5
Acquiror profit after tax th EUR Quarter - 6 | acquiror_profitaftertax_eur_quarter6
Acquiror profit after tax th EUR Quarter - 7 | acquiror_profitaftertax_eur_quarter7
Acquiror profit after tax th EUR Quarter - 8 | acquiror_profitaftertax_eur_quarter8
Acquiror net profit th EUR Year - 1 | acquiror_netprofit_eur_year1
Acquiror net profit th EUR Year - 2 | acquiror_netprofit_eur_year2
Acquiror net profit th EUR Quarter - 1 | acquiror_netprofit_eur_quarter1
Acquiror net profit th EUR Quarter - 2 | acquiror_netprofit_eur_quarter2
Acquiror net profit th EUR Quarter - 3 | acquiror_netprofit_eur_quarter3
Acquiror net profit th EUR Quarter - 4 | acquiror_netprofit_eur_quarter4
Acquiror net profit th EUR Quarter - 5 | acquiror_netprofit_eur_quarter5
Acquiror net profit th EUR Quarter - 6 | acquiror_netprofit_eur_quarter6
Acquiror net profit th EUR Quarter - 7 | acquiror_netprofit_eur_quarter7
Acquiror net profit th EUR Quarter - 8 | acquiror_netprofit_eur_quarter8
Acquiror total assets th EUR Year - 1 | acquiror_totalassets_eur_year1
Acquiror total assets th EUR Year - 2 | acquiror_totalassets_eur_year2
Acquiror total assets th EUR Quarter - 1 | acquiror_totalassets_eur_quarter1
Acquiror total assets th EUR Quarter - 2 | acquiror_totalassets_eur_quarter2
Acquiror total assets th EUR Quarter - 3 | acquiror_totalassets_eur_quarter3
Acquiror total assets th EUR Quarter - 4 | acquiror_totalassets_eur_quarter4
Acquiror total assets th EUR Quarter - 5 | acquiror_totalassets_eur_quarter5
Acquiror total assets th EUR Quarter - 6 | acquiror_totalassets_eur_quarter6
Acquiror total assets th EUR Quarter - 7 | acquiror_totalassets_eur_quarter7
Acquiror total assets th EUR Quarter - 8 | acquiror_totalassets_eur_quarter8
Acquiror net assets th EUR Year - 1 | acquiror_netassets_eur_year1
Acquiror net assets th EUR Year - 2 | acquiror_netassets_eur_year2
Acquiror net assets th EUR Quarter - 1 | acquiror_netassets_eur_quarter1
Acquiror net assets th EUR Quarter - 2 | acquiror_netassets_eur_quarter2
Acquiror net assets th EUR Quarter - 3 | acquiror_netassets_eur_quarter3
Acquiror net assets th EUR Quarter - 4 | acquiror_netassets_eur_quarter4
Acquiror net assets th EUR Quarter - 5 | acquiror_netassets_eur_quarter5
Acquiror net assets th EUR Quarter - 6 | acquiror_netassets_eur_quarter6
Acquiror net assets th EUR Quarter - 7 | acquiror_netassets_eur_quarter7
Acquiror net assets th EUR Quarter - 8 | acquiror_netassets_eur_quarter8
Acquiror shareholders funds th EUR Year - 1 | acquiror_shareholdersfunds_eur_year1
Acquiror shareholders funds th EUR Year - 2 | acquiror_shareholdersfunds_eur_year2
Acquiror shareholders funds th EUR Quarter - 1 | acquiror_shareholdersfunds_eur_quarter1
Acquiror shareholders funds th EUR Quarter - 2 | acquiror_shareholdersfunds_eur_quarter2
Acquiror shareholders funds th EUR Quarter - 3 | acquiror_shareholdersfunds_eur_quarter3
Acquiror shareholders funds th EUR Quarter - 4 | acquiror_shareholdersfunds_eur_quarter4
Acquiror shareholders funds th EUR Quarter - 5 | acquiror_shareholdersfunds_eur_quarter5
Acquiror shareholders funds th EUR Quarter - 6 | acquiror_shareholdersfunds_eur_quarter6
Acquiror shareholders funds th EUR Quarter - 7 | acquiror_shareholdersfunds_eur_quarter7
Acquiror shareholders funds th EUR Quarter - 8 | acquiror_shareholdersfunds_eur_quarter8
Acquiror market capitalisation th EUR Year - 1 | acquiror_marketcapitalisation_eur_year1
Acquiror market capitalisation th EUR Year - 2 | acquiror_marketcapitalisation_eur_year2
Acquiror number of employees Year - 1 | acquiror_numberofemployees_year1
Acquiror number of employees Year - 2 | acquiror_numberofemployees_year2
Acquiror number of employees Quarter - 1 | acquiror_numberofemployees_quarter1
Acquiror number of employees Quarter - 2 | acquiror_numberofemployees_quarter2
Acquiror number of employees Quarter - 3 | acquiror_numberofemployees_quarter3
Acquiror number of employees Quarter - 4 | acquiror_numberofemployees_quarter4
Acquiror number of employees Quarter - 5 | acquiror_numberofemployees_quarter5
Acquiror number of employees Quarter - 6 | acquiror_numberofemployees_quarter6
Acquiror number of employees Quarter - 7 | acquiror_numberofemployees_quarter7
Acquiror number of employees Quarter - 8 | acquiror_numberofemployees_quarter8
Acquiror enterprise value th EUR Year - 1 | acquiror_enterprisevalue_eur_year1
Acquiror enterprise value th EUR Year - 2 | acquiror_enterprisevalue_eur_year2
Acquiror enterprise value th EUR Quarter - 1 | acquiror_enterprisevalue_eur_quarter1
Acquiror enterprise value th EUR Quarter - 2 | acquiror_enterprisevalue_eur_quarter2
Acquiror enterprise value th EUR Quarter - 3 | acquiror_enterprisevalue_eur_quarter3
Acquiror enterprise value th EUR Quarter - 4 | acquiror_enterprisevalue_eur_quarter4
Acquiror enterprise value th EUR Quarter - 5 | acquiror_enterprisevalue_eur_quarter5
Acquiror enterprise value th EUR Quarter - 6 | acquiror_enterprisevalue_eur_quarter6
Acquiror enterprise value th EUR Quarter - 7 | acquiror_enterprisevalue_eur_quarter7
Acquiror enterprise value th EUR Quarter - 8 | acquiror_enterprisevalue_eur_quarter8
Acquiror earnings per share Year - 1 | acquiror_earningspershare_year1
Acquiror earnings per share Year - 2 | acquiror_earningspershare_year2
Acquiror cash flow per share Year - 1 | acquiror_cashflowpershare_year1
Acquiror cash flow per share Year - 2 | acquiror_cashflowpershare_year2
Acquiror dividend per share Year - 1 | acquiror_dividendpershare_year1
Acquiror dividend per share Year - 2 | acquiror_dividendpershare_year2
Acquiror book value per share Year - 1 | acquiror_bookvaluepershare_year1
Acquiror book value per share Year - 2 | acquiror_bookvaluepershare_year2
Target number of outstanding shares First avail. yr | target_numberofoutstandingshares_firstavailyr
Target date of outstanding shares | target_dateofoutstandingshares
Target currency First avail. yr | target_currency_firstavailyr
Target current market capitalisation th LCU First avail. yr | target_currentmarketcapitalisation_lcufirstavailyr
Target date of current market capitalisation | target_dateofcurrentmarketcapitalisation
Target type of share | target_typeofshare
Target ISIN number | target_isinnumber
Target ticker symbol | target_tickersymbol
Target nominal value | target_nominalvalue
Target main exchange | target_mainexchange
Target stock exchange(s) listed | target_stockexchangelisted
Target stock index(es) information | target_stockindexinformation
Target IPO date | target_ipodate
Target listed | target_listed
Acquiror number of outstanding shares First avail. yr | acquiror_numberofoutstandingshares_firstavailyr
Acquiror date of outstanding shares | acquiror_dateofoutstandingshares
Acquiror currency First avail. yr | acquiror_currency_firstavailyr
Acquiror current market capitalisation th LCU First avail. yr | acquiror_currentmarketcapitalisation_lcufirstavailyr
Acquiror date of current market capitalisation | acquiror_dateofcurrentmarketcapitalisation
Acquiror type of share | acquiror_typeofshare
Acquiror ISIN number | acquiror_isinnumber
Acquiror ticker symbol | acquiror_tickersymbol
Acquiror nominal value | acquiror_nominalvalue
Acquiror main exchange | acquiror_mainexchange
Acquiror stock exchange(s) listed | acquiror_stockexchangelisted
Acquiror stock index(es) information | acquiror_stockindexinformation
Acquiror IPO date | acquiror_ipodate
Acquiror listed | acquiror_listed
filename | filename
  
  
- **USDealsOwn data**  
  
  
Original Variable Name | New Variable Name  
:- | :-  
...1 | dborder  
Deal Number | dealnumber  
Target name | targetname
Target BvD ID number | targetbvdidnumber
Target postcode | targetpostcode
Target city | targetcity
Target region within a country | targetregionwithinacountry
Target country | targetcountry
Target country code | targetcountrycode
Acquiror name | acquirorname
Acquiror BvD ID number | acquirorbvdidnumber
Acquiror postcode | acquirorpostcode
Acquiror city | acquirorcity
Acquiror region within a country | acquirorregionwithinacountry
Acquiror country | acquirorcountry
Acquiror country code | acquirorcountrycode
Target status | targetstatus
Target entity type | targetentitytype
Target legal form | targetlegalform
Target date of incorporation | targetdateofincorporation
Target BvD independence indicator | targetbvdindependenceindicator
Target available accounts type(s) | targetavailableaccountstypes
Target filing type | targetfilingtype
Target latest accounts date | targetlatestaccountsdate
Target accounts published in | targetaccountspublishedin
Acquiror status | acquirorstatus
Acquiror entity type | acquirorentitytype
Acquiror legal form | acquirorlegalform
Acquiror date of incorporation | acquirordateofincorporation
Acquiror BvD independence indicator | acquirorbvdindependenceindicator
Acquiror available accounts type(s) | acquiroravailableaccountstypes
Acquiror filing type | acquirorfilingtype
Acquiror latest accounts date | acquirorlatestaccountsdate
Acquiror accounts published in | acquiroraccountspublishedin
Target US SIC description(s) | targetussicdescriptions
Target US SIC code(s) | targetussiccodes
Target primary NAICS 2017 code | targetprimarynaics2017code
Target primary NAICS 2017 description | targetprimarynaics2017description
Target NAICS 2017 code(s) | targetnaics2017codes
Target NAICS 2017 description(s) | targetnaics2017descriptions
Target primary UK SIC (2007) code | targetprimaryuksic2007code
Target primary UK SIC (2007) description | targetprimaryuksic2007description
Acquiror US SIC code(s) | acquirorussiccodes
Acquiror US SIC description(s) | acquirorussicdescriptions
Acquiror primary UK SIC (2007) code | acquirorprimaryuksic2007code
Acquiror primary UK SIC (2007) description | acquirorprimaryuksic2007description
Acquiror primary NAICS 2017 code | acquirorprimarynaics2017code
Acquiror primary NAICS 2017 description | acquirorprimarynaics2017description
Acquiror NAICS 2017 code(s) | acquirornaics2017codes
Acquiror NAICS 2017 description(s) | acquirornaics2017descriptions
Target Shareholders Name | targetshareholdersname
Target Shareholders BvD number | targetshareholdersbvdnumber
Target Shareholders ISO country code | targetshareholdersisocountrycode
Target Shareholders Type | targetshareholderstype
Target Shareholders Direct % | targetshareholdersdirect
Target Shareholders Total % | targetshareholderstotal
Target Shareholders Source | targetshareholderssource
Target Shareholders Date | targetshareholdersdate
Target Shareholders Operating revenuem USD | targetshareholdersoperatingrevenuemusd"
Target Shareholders Total assetsm USD | targetshareholderstotalassetsmusd
Target Shareholders No of employees | targetshareholdersnoofemployees
Acquiror Shareholders Name | acquirorshareholdersname
Acquiror Shareholders BvD number | acquirorshareholdersbvdnumber
Acquiror Shareholders ISO country code | acquirorshareholdersisocountrycode
Acquiror Shareholders Type | acquirorshareholderstype
Acquiror Shareholders Direct % | acquirorshareholdersdirect
Acquiror Shareholders Total % | acquirorshareholderstotal
Acquiror Shareholders Source | acquirorshareholderssource
Acquiror Shareholders Date | acquirorshareholdersdate
Acquiror Shareholders Operating revenuem USD | acquirorshareholdersoperatingrevenuemusd"
Acquiror Shareholders Total assetsm USD | acquirorshareholderstotalassetsmusd"
Acquiror Shareholders No of employees | acquirorshareholdersnoofemployees
filename | filename
  