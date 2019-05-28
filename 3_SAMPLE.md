# Family Business US Merge and Acquisition (M&A) Project

# 3. Sample  
  
### Data Source  
  Database: Zephyr - M&A, IPO, private equity and venture capital deals and rumours  
  Data update: 25-jan-2019  
  - Country: United States of America (US) (Acquiror and Target)  
  - Current deal status: Completed, Withdrawn  

### Restrictions and General Definitions  
**Period** -  10/1995 - 02/2019
  
**Region** -  AE, AR, AT, AU, BE, BM, BR, CA, CH, CM, CN, CO, CZ, DE, DK, DO, ES, FI, FR, GB, HK, HU, IE, IL, IN, IT, JM, JP, KR, KW, MT, MX, NA, NL, NZ, PA, PE, PH, PL, PR, RO, SE, SG, TH, TW, UA, US, UY, VE, VG, VN, ZA  
  
**Company Type**  
only companies listed on the stock Exchange  
  
**Firm Control**  
control is defined if the owner owns at least 50% of the company shares or 25% if the company is listed.  
  
  
### Variables Measures  


#### [**H1.**] Ownership Similarity and Target Selection  

**Acquisition Occurrence**  
Dummy assumes value 1 if:  
USDeals.'Deal Status' = {'Completed', 'Completed Assumed'} and  


USDealsFin.'Target Listed' | Deal.initialstake | Deal.finalstake | USDeals.'Deal Types' | Dummy  
:---- | :----: | :----: | :----: | :----:
"Listed" | < 50 | >= 50 | * | 1  
  | | "Unknown %" | "Unknown %" | 'Acquisition 100%'; 'Acquisition 50%'; 'Acquisition 51%'; 'Acquisition increased from 12% to 100%'; 'Acquisition increased from 36.952% to 100%'; 'Merger 100%'; 'Acquisition unknown majority stake %'; 'Institutional buy-out 100%'; 'Institutional buy-out 90%'; 'Institutional buy-out majority stake'; 'Institutional buy-out unknown majority stake %' | 1  
    
  
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