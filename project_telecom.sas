/*TELECOM COMMUNICATIONS*/


LIBNAME PROJECT "D:\MCT\Advance SAS\";

/*Importing the Dataset*/

DATA PROJECT.TELECOM;
INFILE "D:\MCT\Advance SAS\PROJECT\New_Wireless_Fixed.txt" TRUNCOVER;
INPUT
  @1 Acctno $13.
  @15 Actdt mmddyy10. 
  @26 Deactdt mmddyy10.
  @41 DeactReason $4.
  @53 GoodCredit
  @62 PlanRate
  @65 DealerType $2.
  @73 Age 
  @80 Province $2.
  @85 Sales_amt dollar10.2
;
FORMAT actdt deactdt mmddyy10.;
FORMAT sales_amt dollar10.2;
RUN;

PROC PRINT DATA=PROJECT.TELECOM;
RUN;

/*Describe the DATAset*/
PROC CONTENTS DATA=PROJECT.TELECOM;
RUN;

/*Handle Missing Values*/
PROC MEANS DATA=PROJECT.TELECOM NMISS MODE MIN MAX MEAN MEDIAN;
RUN;
/*Age Column and Sales_amt column has missing values
We will replace the missing value with Median*/

PROC STDIZE DATA=PROJECT.TELECOM
	OUT=PROJECT.MISSINGAGE 
	REPONLY METHOD=MEDIAN;
	VAR Age sales_amt;
RUN;

PROC PRINT DATA==PROJECT.MISSINGAGE;
RUN;

/* Checking missing values for categorical value*/

PROC FREQ DATA=PROJECT.MISSINGAGE;
TABLES Province DealerType DeactReason /MISSING;
RUN;


/*checking mode for the column Province*/
PROC SQL;
SELECT PROVINCE,COUNT(PROVINCE) AS TOTAL_REPETATIONS
FROM PROJECT.MISSINGAGE
GROUP BY PROVINCE
ORDER BY TOTAL_REPETATIONS DESC;
QUIT;

/*As per the above query Province ON is frequently occured */
DATA PROJECT.TELECOM1;
SET PROJECT.MISSINGAGE;
IF PROVINCE="" THEN PROVINCE="ON";
RUN;

PROC PRINT DATA=PROJECT.TELECOM1;
RUN;


/*Rechecking the missing value in province column*/
PROC FREQ DATA=PROJECT.TELECOM1;
TABLES Province DealerType DeactReason/ MISSING;
RUN;


/*1.1  Explore and describe the DATAset briefly. For example, is the acctno unique? What
is the number of accounts activated and deactivated? When is the earliest and
latest activation/deactivation dates available? And so on�.
*/

/*Is Account Number Unique?*/
PROC SQL;
SELECT DISTINCT COUNT(Acctno) AS TOTAL_ACCNUM 
FROM PROJECT.TELECOM
;
QUIT;

/*Yes, the Account number is unique - no duplicates found*/

/*What is the number of accounts activated and deactivated?*/
DATA PROJECT.TELE;
SET PROJECT.TELECOM1;
IF Deactdt EQ '' THEN STATUS="ACTIVE  ";
ELSE STATUS="INACTIVE";
RUN;

PROC PRINT DATA=PROJECT.TELE;
RUN;
/*How many number of accounts are Active and Inactive*/
PROC SQL;
SELECT 'No_of_Deactive_Acc',COUNT(*) FROM PROJECT.TELE WHERE STATUS EQ 'INACTIVE'
UNION
SELECT 'No_of_Active_Acc',COUNT(*) FROM PROJECT.TELE WHERE STATUS EQ 'ACTIVE'
;
QUIT;


/*When is the earliest and latest activation/deactivation dates available? */

DATA PROJECT.ACTIVE PROJECT.INACTIVE;
SET PROJECT.TELE;
IF STATUS='ACTIVE' THEN OUTPUT PROJECT.ACTIVE;
ELSE OUTPUT PROJECT.INACTIVE;
RUN;
PROC PRINT DATA=PROJECT.ACTIVE;
RUN;
PROC PRINT DATA=PROJECT.INACTIVE;
RUN;

PROC SQL;
SELECT
MIN(Actdt) AS Earliest_Act_Date FORMAT=MMDDYY10.,
MAX(Actdt) AS Latest_Act_Date FORMAT=MMDDYY10.
FROM PROJECT.ACTIVE
;
QUIT;

PROC SQL;
SELECT
MIN(Deactdt) AS Earliest_Deact_Date FORMAT=MMDDYY10.,
MAX(Deactdt) AS Latest_Deact_Date FORMAT=MMDDYY10.
FROM PROJECT.INACTIVE
;
QUIT;

FOOTNOTE "Generated by SAS(&_SASSERVERNAME, &SYSSCPL) on %TRIM(%QSYSFUNC(DATE(), NLDATE20.)) 
           at %TRIM(%QSYSFUNC(TIME(), NLTIMAP25.))";

/*What is the age and province distributions of active and deactivated customers?*/

ODS GRAPHICS ON/MAXLEGENDAREA=100;
PROC FREQ DATA=Project.TELE;
TABLES AGE*PROVINCE/PLOTS(ONLY)=FREQPLOT(TWOWAY=STACKED);
RUN;
ODS GRAPHICS OFF;

ODS GRAPHICS ON;
PROC ANOVA DATA=PROJECT.TELE PLOTS(MAXPOINTS=NONE) ;
CLASS PROVINCE;
MODEL AGE=PROVINCE;
RUN;
ODS GRAPHICS OFF;
/*Graphical Representation of Age and Province for Active and Inactive customers*/
PROC SGPLOT DATA=PROJECT.ACTIVE;
VBAR PROVINCE/RESPONSE=AGE STAT=PERCENT 
 GROUP = PROVINCE GROUPDISPLAY = CLUSTER DATALABEL ;
TITLE "DISTRIBUTION OF AGE AND PROVINCE FOR ACTIVE CUSTOMER";
RUN;

PROC SGPLOT DATA=PROJECT.INACTIVE;
VBAR PROVINCE/RESPONSE=AGE STAT=PERCENT 
 GROUP = PROVINCE GROUPDISPLAY = CLUSTER DATALABEL ;
TITLE "DISTRIBUTION OF AGE AND PROVINCE FOR INACTIVE CUSTOMER";
RUN;		   

/*IS AGE IS NORMALY DISTRIBUTED*/

PROC SGPLOT DATA=PROJECT.TELE;
VBAR PROVINCE/RESPONSE=AGE STAT=PERCENT 
 GROUP = AGE GROUPDISPLAY = CLUSTER DATALABEL ;
TITLE "AGE IS NORMALLY DISTRIBUTED OVER PROVINCE";
RUN;

/*Segment the customers based on age, province and sales amount:
Sales segment: < $100, $100---500, $500-$800, $800 and above.
Age segments: < 20, 21-40, 41-60, 60 and above.
*/

PROC FORMAT;
VALUE AGEFOR
    0-<20='YOUNG'
	20-<30='TEEN'
	30-<50='ADULT'
	50-<70='MATURE'
	70 -high='SENIOR'	
;
VALUE SALFOR
   0-<100='FAIR'
   100-500='NORMAL'
   501-800='GOOD'
   801-high='EXCELENT'
 ;
 VALUE CREDITFMT
 1='GOOD CREDIT'
 0='BAD CREDIT'
 ;
RUN;

PROC PRINT DATA=PROJECT.TELE;
FORMAT AGE AGEFOR. SALES_AMT SALFOR.;
RUN;

PROC GPLOT DATA=PROJECT.TELE;
PLOT SALES_AMT*AGE=PROVINCE/HMINOR=0;
RUN;

PROC SQL;
CREATE TABLE PROJECT.ASP AS
SELECT  AGE FORMAT AGEFOR.,PROVINCE,SALES_AMT 
FROM PROJECT.TELE
;
QUIT; 

PROC SGPANEL DATA=PROJECT.ASP;
TITLE"Association of Sales Amount,Province and Age";
PANELBY PROVINCE;
DOT AGE/RESPONSE=SALES_AMT STAT=PERCENT DATALABEL
GROUPDISPLAY=CLUSTER NOSTATLABEL COLORMODEL=TWOCOLORRAMP DATASKIN=GLOSS;
RUN;

/*STATISTICAL ANALYSIS*/
/*Calculate the tenure in days for each account and give its simple statistics.*/
DATA PROJECT.TENURE;
SET PROJECT.TELE;
IF DEACTDT EQ '' THEN TENURE_IN_DAYS=INTCK('DAY',ACTDT,'31Jan2001'd);
ELSE TENURE_IN_DAYS=DEACTDT-ACTDT;
TENURE_FORMAT=TENURE_IN_DAYS;
RUN;

PROC PRINT DATA=PROJECT.TENURE;
FORMAT DEACTDT MMDDYY10.;
RUN;

ODS GRAPHICS ON; 
PROC UNIVARIATE DATA=PROJECT.TENURE NORMAL PLOT;
VAR TENURE_IN_DAYS;
RUN;
ODS GRAPHICS OFF;

/*Calculate the number of accounts deactivated for each month.*/

PROC FREQ DATA=PROJECT.INACTIVE;
TABLES DEACTDT/NOCUM ;
FORMAT DEACTDT MONYY7.;
RUN;

PROC GCHART DATA=PROJECT.INACTIVE;
TITLE"FREQUENCY OF DEACTIVATION REASON";
  PIE3D DEACTREASON/discrete 
             value=inside
             percent=outside
             EXPLODE=ALL
			 SLICE=OUTSIDE
			 RADIUS=20
;
RUN;


/*Segment the account, first by account status �Active� and �Deactivated�, then by
Tenure: < 30 days, 31---60 days, 61 days--- one year, over one year. Report the
number of accounts of percent of all for each segment.
*/

/*SEGMENT THE ACCOUNT BY STATUS*/
DATA PROJECT.ACTIVE PROJECT.INACTIVE;
SET PROJECT.TELE;
IF STATUS='ACTIVE' THEN OUTPUT PROJECT.ACTIVE;
ELSE OUTPUT PROJECT.INACTIVE;
RUN;
PROC PRINT DATA=PROJECT.ACTIVE;
RUN;
PROC PRINT DATA=PROJECT.INACTIVE;
RUN;


PROC FORMAT;
VALUE TENFMT
0-<31='30 DAYS'
31-<61='31-60 DAYS'
61-<366='61 DAYS - 1 YEAR'
366-HIGH='OVER 1 YEAR'
;
RUN;

PROC PRINT DATA=PROJECT.TENURE;
FORMAT TENURE_FORMAT TENFMT.;
RUN;

/*Report the number of accounts of percent of all for each segment*/
PROC SQL;
CREATE TABLE PROJECT.TENUREFMT AS
SELECT STATUS,TENURE_FORMAT FORMAT TENFMT.
FROM PROJECT.TENURE
;
QUIT;

PROC GCHART DATA=PROJECT.TENUREFMT;
TITLE"FREQUENCY OF ACCOUNTS FOR EACH SEGMENTS";
  PIE3D status/discrete 
             value=inside
             percent=outside
             EXPLODE=ALL
			 SLICE=OUTSIDE
			 RADIUS=20
;
RUN;

PROC SGPLOT DATA=PROJECT.TENUREFMT;
VBAR STATUS/GROUP=TENURE_FORMAT STAT=PERCENT 
 GROUP = STATUS GROUPDISPLAY = CLUSTER DATALABEL ;
TITLE "PERCENTAGE OF ACCOUNTS DISTRIBUTION OVER TENURE SEGMENTS";
RUN;

ODS GRAPHICS ON;
PROC FREQ DATA=PROJECT.TENUREFMT;
TABLES STATUS*TENURE_FORMAT/CHISQ;
RUN;
ODS GRAPHICS OFF;


/*Test the general association between the tenure segments and �Good Credit�
�RatePlan � and �DealerType.�
*/


PROC SQL;
CREATE TABLE PROJECT.ASS_DATA AS
SELECT TENURE_FORMAT FORMAT TENFMT.,GOODCREDIT FORMAT CREDITFMT.,PLANRATE,DEALERTYPE
FROM PROJECT.TENURE
;
QUIT;


	
ODS GRAPHICS ON;
PROC CORR DATA=PROJECT.ASS_DATA PEARSON SPEARMAN;
VAR TENURE_FORMAT GOODCREDIT PlanRate;
TITLE'CORRELATION';
RUN;
ODS GRAPHICS OFF;

/*RELATIONSHIP BETWEEN DEALER TYPE, TENURE,GOODCREDIT AND PLANRATE */
PROC MEANS DATA=PROJECT.ASS_DATA MIN MAX STDDEV MEAN MAXDEC=2;
VAR PlanRate;
CLASS DealerType TENURE_FORMAT GOODCREDIT;
RUN;

/*ASSOCIATION BETWEEN TENURE AND GOODCREDIT*/
PROC FREQ DATA=PROJECT.ASS_DATA;
TABLE TENURE_FORMAT*GOODCREDIT/CHISQ;
TITLE"ASSOCIATION BETWEEN TENURE AND GOODCREDIT";
RUN;

PROC SGPLOT DATA=PROJECT.ASS_DATA;
VBAR TENURE_FORMAT/GROUP=GOODCREDIT STAT=PERCENT CLUSTERWIDTH=0.5 
GROUPDISPLAY=CLUSTER DATALABEL;
TITLE"ASSOCIATION BETWEEN TENURE AND GOODCREDIT";
RUN;

/*ASSOCIATION BETWEEN TENURE AND PLANRATE*/
PROC FREQ DATA=PROJECT.ASS_DATA;
TABLE  TENURE_FORMAT*DEALERTYPE/CHISQ;
TITLE"ASSOCIATION BETWEEN TENURE AND DEALERTYPE";
RUN;

PROC SGPLOT DATA=PROJECT.ASS_DATA;
VBAR TENURE_FORMAT/GROUP=PLANRATE STAT=PERCENT CLUSTERWIDTH=0.5 
GROUPDISPLAY=CLUSTER DATALABEL;
TITLE"ASSOCIATION BETWEEN TENURE AND PLANRATE";
RUN;

/*ASSOCIATION BETWEEN TENURE AND DEALERTYPE*/

PROC FREQ DATA=PROJECT.ASS_DATA;
TABLE  TENURE_FORMAT*DEALERTYPE/CHISQ;
TITLE"ASSOCIATION BETWEEN TENURE AND DEALERTYPE";
RUN;

PROC SGPLOT DATA=PROJECT.ASS_DATA;
VBAR TENURE_FORMAT/GROUP=DEALERTYPE STAT=PERCENT CLUSTERWIDTH=0.8 
GROUPDISPLAY=CLUSTER DATALABEL;
TITLE"ASSOCIATION BETWEEN TENURE AND DEALERTYPE";
RUN;

/*ASSOCIATION BETWEEN PLANRATE AND DEALERTYPE*/

PROC FREQ DATA=PROJECT.ASS_DATA;
TABLE  PLANRATE*DEALERTYPE/CHISQ;
TITLE"ASSOCIATION BETWEEN PLANRATE AND DEALERTYPE";
RUN;

PROC SGPLOT DATA=PROJECT.ASS_DATA;
VBAR PLANRATE/GROUP=DEALERTYPE STAT=PERCENT CLUSTERWIDTH=0.8 
GROUPDISPLAY=CLUSTER DATALABEL;
TITLE"ASSOCIATION BETWEEN PLAN_RATE AND DEALERTYPE";
RUN;

/*Is there any association between the account status and the tenure segments?
Could you find out a better tenure segmentation strategy that is more associated
with the account status?*/

PROC FORMAT;
VALUE BETTERTENFMT
0-<31 ='1 MONTH'
31-<91 ='1-3 MONTHS'
91-<181 ='3-6 MONTHS'
181-<271 = '6-9 MONTHS'
271-<366='9-12 MONTHS'
366-<1096='1-3 YEARS'
;
RUN;

PROC SQL;
CREATE TABLE PROJECT.ACC_STATUS_TENURE AS
SELECT STATUS,TENURE_FORMAT FORMAT BETTERTENFMT.,TENURE_IN_DAYS
FROM PROJECT.TENURE
;
QUIT;

PROC PRINT DATA=PROJECT.ACC_STATUS_TENURE;
RUN;
/*Association Between Status and Tenure*/
PROC FREQ DATA=PROJECT.ACC_STATUS_TENURE;
TABLES STATUS*TENURE_FORMAT/CHISQ;
TITLE"Association Between Status and Tenure";
RUN;

PROC SGPLOT DATA=PROJECT.ACC_STATUS_TENURE;
VBAR STATUS/GROUP=TENURE_FORMAT NOSTATLABEL STAT=PERCENT DATALABEL
GROUPDISPLAY=CLUSTER  DATASKIN=GLOSS;
YAXIS GRID;
TITLE ASSOCIATION BETWEEN ACCOUNT_STATUS AND TENURE;
RUN;
/*Observation: Inactive account are active only for short period maximum is less than only
only few accounts are deactivated after one year whereas active accounts are active more than one year */

/*Does Sales amount differ among different account status, good credit, and
customer age segments?*/


PROC SQL;
CREATE TABLE PROJECT.SALESSEG AS
SELECT SALES_AMT FORMAT SALFOR.,STATUS,GOODCREDIT FORMAT CREDITFMT.,
AGE FORMAT AGEFOR.
FROM PROJECT.TENURE
;
QUIT;

PROC PRINT DATA=PROJECT.SALESSEG;
RUN;

/*Sales Amount differ from Account status*/
ODS GRAPHICS ON;
PROC SGPLOT DATA=PROJECT.SALESSEG;
VBAR SALES_AMT/GROUP=STATUS GROUPDISPLAY=CLUSTER DATASKIN=GLOSS BARWIDTH=0.5;
YAXIS GRID;
TITLE'SALES AMOUNT DIFFERS FROM STATUS';
RUN;
ODS GRAPHICS OFF;


/*SALES AMOUNT DIFFER FROM AGE*/
PROC SGPLOT DATA=PROJECT.SALESSEG;
VBAR SALES_AMT/GROUP=AGE GROUPDISPLAY=CLUSTER DATASKIN=SHEEN BARWIDTH=0.5;
YAXIS GRID;
TITLE'SALES AMOUNT DIFFER FROM AGE';
RUN;

/*SALES AMOUNT DIFFER FROM GOOD CREDIT*/
PROC SGPLOT DATA=PROJECT.SALESSEG;
VBAR SALES_AMT/GROUP=GOODCREDIT GROUPDISPLAY=CLUSTER DATASKIN=GLOSS BARWIDTH=0.5;
YAXIS GRID;
TITLE'SALES AMOUNT DIFFER FROM GOOD CREDIT';
INSET "SALES AMOUNT AND GOODCREDIT";
RUN;

/*ASSOCIATION BETWEEN SALES_AMOUNT,GOODCREDIT,AGE AND STATUS*/
PROC SGPANEL DATA=PROJECT.SALESSEG;
PANELBY STATUS GOODCREDIT;
VBAR AGE/RESPONSE=SALES_AMT GROUPDISPLAY=CLUSTER CLUSTERWIDTH=0.5 stat=freq datalabel;
TITLE"ASSOCIATION BETWEEN SALES_AMOUNT,GOODCREDIT,AGE AND STATUS";
RUN;


/*Anova for sales amount and age*/
ODS GRAPHICS ON;
PROC ANOVA DATA=PROJECT.SALESSEG;
CLASS SALES_AMT;
MODEL AGE=SALES_AMT;
MEANS SALES_AMT;
RUN;
ODS GRAPHICS OFF;


/*NORMALITY TEST FOR SALES_AMOUNT AND AGE*/
ODS GRAPHICS ON;
PROC UNIVARIATE DATA=PROJECT.SALESSEG NORMAL PLOT;
VAR AGE SALES_AMT;
RUN;
ODS GRAPHICS OFF;