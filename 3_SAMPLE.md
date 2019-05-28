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
  
### Variables Dictionary
See Appendix A.  
  
### Variables Measures


#### [**H1.**] Ownership Similarity and Target Selection

**New Acquisition Occurrence** [newao]  
a variable assumes values other than zero when the transaction status has been completed and the initial stake is equal to zero. Under these conditions the variable assumes the values:  
(1) if final stake > 50%; 
(2) if final stake = 50%; 
(0) otherwise.  
  
In cases that the initial stake and final stake are *'Unknow %'* the levels are measured with the variable *dealtypes*. And a dummy *newao_origin* are created for control the origin of the measurement. It assumes value 0 if *newao* are obtained from *initialstake* and 1 from *dealtypes*.  
  
**Questions**:  
- Does *USDealsFin.'Target status'* have influence?  
*{Active, Active (dormant), Active (insolvency proceedings), Bankruptcy, Dissolved, Dissolved (merger or take-over), In liquidation, Inactive (no precision)}*  
  
  
**Ownership Correspondence** -  
  
**Ownership Commitment Similarity** -  
  
**Family Involvement Similarity** -  
  
**State** -  
  
**Relative performance** -  

**Relative size** -  
  
**Business similarity** -  
  
**Similarity Ownership Concentration** -  
  
**Geographical similarity** -  
  
**Industry Concentration** -  

**Cash Slack** -  
  
    
#### [**H2.**] New Deals and Performance  
  
**New Deal Occurrence** -  
  
  
  
#### Appendix A - Variables Dictionary    
  
* **USDeals.xlsx variables**  

Original Name | New Name | Description  
:- | :- | :-  
- | dborder | -  
Deal Number | dealnumber | -  
Deal value th EUR...3 | dealvalueEUR | -  
Deal value (Native currency) th LCU | dealvalueNative | -  
Deal equity value th EUR | dealequityvalueEUR | -  
Deal equity value (Native currency) th LCU | dealequityvalueEURNative | -  
Deal enterprise value th EUR | dealenterprisevalueEUR | -  
Deal enterprise value (Native currency) th LCU | dealenterprisevalueNative | -  
Deal modelled enterprise value th EUR | dealmodelledenterprisevalueEUR | -  
Deal modelled enterprise value (Native currency) th LCU | dealmodelledenterprisevalueNative | -  
Deal total target value th EUR | dealtotaltargetvalueEUR | -  
Deal total target value (Native currency) th LCU | dealtotaltargetvalueNative | -  
Initial stake (%) | initialstake | -  
Acquired stake (%) | acquired stake | -  
Final stake (%) | finalstake | -  
Native currency | nativecurrency | -  
Deal type...20 | dealtype | -  
Deal status...25 | dealstatus | -  
Rumour date | daterumour | -  
Announced date | dateannounced | -  
Completed date | datecompleted | -  
Last deal status date | datelastdealstatus | -  
Last update | datelastupdate | -  
Deal headline | dealheadline | -  
Deal type...42 | dealtypeb | -  
Deal value th EUR...44 | dealvalueEURb | -  
Target name | targetname | -  
Target country code | targetcountrycode | -  
Target business description(s) | targetbusinessdescription | -  
Target BvD ID number | targetBvDID | -  
Acquiror name | acquirorname | -  
Acquiror country code | acquirorcountrycode | -  
Acquiror business description(s) | acquirorbusinessdescription | -  
Acquiror BvD ID number | acquirorBvDIDnumber | -  
Group acquiror name | groupacquirorname | -  
Group acquiror country code | groupacquirorcountrycode | -  
Group acquiror business description(s) | groupacquirorbusinessdescription | -  
Group acquiror BvD ID number | groupacquirorBvDID | -  
Vendor name | vendorname | -  
Vendor country code | vendorcountrycode | -  
Vendor business description(s) | vendorbusinessdescription(s) | -  
Vendor BvD ID number | vendorBvDID | -  
Group vendor name | groupvendorname | -  
Group vendor country code | groupvendorcountrycode | -  
Group vendor business description(s) | groupvendorbusinessdescription | -  
Group vendor BvD ID number | groupvendorBvDID | -  
filename | filename | -  
  