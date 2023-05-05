/*CREATING LIBRARY*/
libname SASBF "D:\MCT\SAS PROJECT\BFProject";

/*IMPORTING THE FILE*/
PROC IMPORT DATAFILE='D:\MCT\SAS PROJECT\Dataset\train.csv'
     OUT=SASBF.BlackFriday
     DBMS=csv REPLACE;
     GETNAMES=YES;
RUN;
/*VIEW THE DATA*/
PROC PRINT DATA=SASBF.BLACKFRIDAY(obs= 100);
RUN;
title;
/*DESCRIPTIVE ANALYSIS*/
PROC CONTENTS data=SASBF.BlackFriday;
RUN;
/*There are 5 Categorical Variable and 7 Numerical Variable*/

/*CHECKING MISSING VALUES*/
TITLE "Null Values in all variables";
/* CREATE A FORMAT TO GROUP MISSING AND NONMISSING */
PROC FORMAT;
 VALUE $MISSFMT ' '='MISSING' OTHER='NOT MISSING';
 VALUE  MISSFMT  . ='MISSING' OTHER='NOT MISSING';
RUN;

PROC FREQ DATA=SASBF.BlackFriday; 
FORMAT _CHAR_ $MISSFMT.; /* APPLY FORMAT FOR THE DURATION OF THIS PROC*/
TABLES _CHAR_ / MISSING MISSPRINT NOCUM NOPERCENT;
FORMAT _NUMERIC_ MISSFMT.;
TABLES _NUMERIC_ / MISSING MISSPRINT NOCUM NOPERCENT;
RUN;

/*FORMAT PROCEDURES*/
PROC FORMAT;
  value occupation_fmt
  0 = 'Executive/Managerial'
  1 = 'Professional'
  2 = 'Self-Employed'
  3 = 'Skilled Trades'
  4 = 'Sales'
  5 = 'Customer Service'
  6 = 'IT/Technical'
  7 = 'Healthcare Professional'
  8 = 'Education'
  9 = 'Finance'
  10 = 'Marketing'
  11 = 'Creative'
  12 = 'Administrative'
  13 = 'Legal'
  14 = 'Military/Security'
  15 = 'Hospitality'
  16 = 'Agriculture'
  17 = 'Manufacturing'
  18 = 'Transportation/Logistics'
  19 = 'Student'
  20 = 'Unemployed';

value marital_fmt
  0='Single'
  1='Married';

value $cityfmt
'A' = 'Small Town'
'B' = 'Mid Town'
'C' = 'Metropolitan Area';
RUN;

PROC FORMAT;
VALUE prodcat_1_fmt 
0='Other'
1='Electronics' 
2='Clothing ' 
3='Home Appliances' 
4='Furnitures' 
5='Beauty Products'  
6='Sports Activities'  
7='Automobiles'  
8='Toys/Games'  
9='Food/Beverages'  
10='Books/Stationery'  
11='Entertainments' 
12='Health Product' 
13='Travel' 
14='Pet Supplies'  
15='Office Supplies' 
16='Art/Craft Supplies'  
17='Baby Products' 
18='Industrial Products'
19='Miscellaneous Products'  
20='Gift Cards';
RUN;
PROC FORMAT;
VALUE  prodcat_2_fmt 
2 ='Clothing'
3='Footwear'
4='Automotive'
5='Furniture'
6='Electronics'
7='Home Decor'
8='Cookware & Bakeware'
9='Home Appliances'
10='Outdoor Living'
11 ='Personal Care'
12 ='Home Improvement'
13='Musical Instruments'
14='Toys & Games'
15='Luggage'
16='Cameras & Accessories'
17='Stationery'
18='Watches';
RUN;
PROC FORMAT;
VALUE  prodcat_3_FMT
3 ='Mens Clothing'
4='Car Accessories'
5='Furniture'
6='Mobiles'
7='Home Furnishing'
8='Kitchen Appliances'
9='TVs & Appliances'
10 ='Outdoor & Garden'
11='Personal Care Appliances'
12='Tools & Hardware'
13='Musical Instruments'
14='Toy, Kids & Baby'
15='Bags, Wallets & Belts'
16='Cameras & Accessories'
17='Art, Craft & Party Supplies'
18='Watches';
RUN;

/*FORMATTING THE NUMERICAL VALUES TO CATEGORIES*/
DATA SASBF.BFDATAFMT;
  SET SASBF.BLACKFRIDAY;
    FORMAT occupation occupation_fmt.;
   FORMAT Marital_Status marital_fmt.;
     FORMAT PRODUCT_CATEGORY_1 prodcat_1_FMT.;
   FORMAT Product_Category_2 prodcat_2_FMT.; 
   FORMAT Product_Category_3 prodcat_3_FMT.;
   FORMAT City_Category  cityfmt.;
   FORMAT Purchase DOLLAR10.2;
RUN;
PROC PRINT DATA=SASBF.BFDATAFMT(obs= 150);
RUN;

title;

/*HANDLING MISSING VLAUES*/
data SASBF.BFDATA;
    set SASBF.BFDATAFMT;
    format PROD_CATEGORY $25.; /* set the format for the new categorical column */
    if PRODUCT_CATEGORY_2 =2 then prod_category = "Clothing";
	else if PRODUCT_CATEGORY_2 =3 then prod_category = "Footwear";
	else if PRODUCT_CATEGORY_2 =4 then prod_category = "Automotive";
	else if PRODUCT_CATEGORY_2 =5 then prod_category = "Furniture";
	else if PRODUCT_CATEGORY_2 =6 then prod_category = "Electronics";
	else if PRODUCT_CATEGORY_2 =7 then prod_category = "Home Decor";
	else if PRODUCT_CATEGORY_2 =8 then prod_category = "Cookware and Bakeware";
	else if PRODUCT_CATEGORY_2 =9 then prod_category = "Home Appliances";
	else if PRODUCT_CATEGORY_2 =10 then prod_category = "Outdoor Living";
	else if PRODUCT_CATEGORY_2 =11 then prod_category = "Personal Care";
	else if PRODUCT_CATEGORY_2 =12 then prod_category = "Home Improvement";
	else if PRODUCT_CATEGORY_2 =13 then prod_category = "Musical Instruments";
	else if PRODUCT_CATEGORY_2 =14 then prod_category = "Toys&Games";
	else if PRODUCT_CATEGORY_2 =15 then prod_category = "Luggage";
	else if PRODUCT_CATEGORY_2 =16 then prod_category = "Camera and Accessories";
	else if PRODUCT_CATEGORY_2 =17 then prod_category = "Stationery";
	else if PRODUCT_CATEGORY_2 =18 then prod_category = "Watches";
	else prod_category = "Unknown";
    drop PRODUCT_CATEGORY_2; /* drop the original numerical column */
    rename prod_category = Product_Category_2; /* rename the new categorical column as "age"*/

	/*Product category 3*/
    format PRODU_CATEGORY $45.; /* set the format for the new categorical column */
    if PRODUCT_CATEGORY_3 =3 then produ_category = "Mens Clothing                           ";
	else if PRODUCT_CATEGORY_3 =4 then produ_category = "Car Accessories";
	else if PRODUCT_CATEGORY_3 =5 then produ_category = "Furniture";
	else if PRODUCT_CATEGORY_3 =6 then produ_category = "Mobiles";
	else if PRODUCT_CATEGORY_3 =7 then produ_category = "Home Furnishing";
	else if PRODUCT_CATEGORY_3 =8 then produ_category = "Kitchen Appliances";
	else if PRODUCT_CATEGORY_3 =9 then produ_category = "TVs & Appliances";
	else if PRODUCT_CATEGORY_3 =10 then produ_category = "Outdoor & Garden";
	else if PRODUCT_CATEGORY_3 =11 then produ_category = "Personal Care Appliances";
	else if PRODUCT_CATEGORY_3 =12 then produ_category = "Tools & Hardware";
	else if PRODUCT_CATEGORY_3 =13 then produ_category = "Musical Instruments";
	else if PRODUCT_CATEGORY_3 =14 then produ_category = "Toy, Kids & Baby";
	else if PRODUCT_CATEGORY_3 =15 then produ_category = "Bags, Wallets & Belts";
	else if PRODUCT_CATEGORY_3 =16 then produ_category = "Cameras & Accessories";
	else if PRODUCT_CATEGORY_3 =17 then produ_category = "Art, Craft & Party Supplies";
	else if PRODUCT_CATEGORY_3 =18 then produ_category = "Watches";
	else produ_category = "Unknown";
    drop PRODUCT_CATEGORY_3; /* drop the original numerical column */
    rename produ_category = Product_Category_3; /* rename the new categorical column as "age"*/
  run;

PROC PRINT DATA=SASBF.BFDATA(OBS=100);
RUN;

/*CHECKING*/
PROC CONTENTS DATA=SASBF.BFDATA;
RUN;


/*CONCATENATE SUB-PRODUCT CATEGORIES*/
DATA SASBF.BFCLEANDATA;
SET SASBF.BFDATA;
DIST_PROD= CATX('-',PRODUCT_CATEGORY_2, PRODUCT_CATEGORY_3);
RUN;

PROC PRINT DATA=SASBF.BFCLEANDATA;
RUN;


*========================================;
*----- UNIVARIATE ANALYSIS---------------;
*========================================;
/* Column Product_category_1*/
PROC UNIVARIATE DATA=SASBF.BFCLEANDATA;
   VAR Product_Category_1;
RUN;
PROC SGPLOT DATA=SASBF.BFCLEANDATA;
TITLE "PRODUCT_CATEGORY_1";
VBAR PRODUCT_CATEGORY_1;
RUN;
 
/*INFERENCE:*/
/*Beauty Products,Electronics, are sold high in category_1 followed by Toys and Games*/

/*Column Product_category_2*/
PROC UNIVARIATE DATA=SASBF.BFCLEANDATA;
   VAR Product_Category_2;
RUN;
PROC SGPLOT DATA=SASBF.BFCLEANDATA;
TITLE "PRODUCT_CATEGORY_2";
VBAR PRODUCT_CATEGORY_2;
RUN;
/*INFERENCE*/
/*The category "Toys and Games" is sold high*/
/*Followed by Beauty Products and Pet Supllies*/

/*Column Product_Category_3*/
PROC UNIVARIATE DATA=SASBF.BFCLEANDATA;
   VAR Product_Category_3;
RUN;
PROC SGPLOT DATA=SASBF.BFCLEANDATA;
TITLE "PRODUCT_CATEGORY_3";
VBAR PRODUCT_CATEGORY_3;
RUN;
/*INFERENCE*/
/*Sale of Unknown Category is high -- because 70% of the data is missing and replaced with "UNKNOWN" */
title;
/*Column Purchase*/
PROC UNIVARIATE DATA=SASBF.BFCLEANDATA;
   histogram Purchase/normal;
RUN;
/*INFERENCE:*/
/*The Highest Purchase was $23958*/
/*The Lowest Purchase was $189*/

/*COLUMN MARITAL_STATUS*/
PROC UNIVARIATE DATA=SASBF.BFCLEANDATA;
   var MARITAL_STATUS;
RUN;
PROC SGPLOT DATA=SASBF.BFCLEANDATA;
TITLE "MARITAL_STATUS";
VBAR MARITAL_STATUS;
RUN;

/*INFERENCE:*/
/*The Purchase made by Singles are high compared to Married*/

/*Column Product ID*/
PROC FREQ DATA=SASBF.BFCLEANDATA;
table Product_ID;
run;
/*Inference*/

/*COLUMN GENDER*/
PROC FREQ DATA=SASBF.BFCLEANDATA;
TABLE GENDER;
RUN;
PROC SGPLOT DATA=SASBF.BFCLEANDATA;
TITLE "GENDER";
VBAR GENDER;
RUN;
/*INFERENCE:*/
/*72% of Purchase was made by Males*/
/*28% of purchase was made by Females*/
/*Males purchase high during Black Friday*/


/*COLUMN AGE*/
PROC FREQ DATA=SASBF.BFCLEANDATA;
TABLE AGE;
RUN;
PROC SGPLOT DATA=SASBF.BFCLEANDATA;
TITLE "AGE FREQUENCY";
VBAR AGE;
RUN;
/*INFERENCE:*/
/* The Age group 26-35 likely to purchase more when compared to 36-45.*/
/* There is a slight difference in the purchase for the age group 36-45 and 18-25*/
/* The age group 0-17 is the lowest when compare to age group 55+*/

/*COLUMN CITY_CATEGORY*/
PROC FREQ DATA=SASBF.BFCLEANDATA;
TABLE City_Category;
RUN;
PROC SGPLOT DATA=SASBF.BFCLEANDATA;
TITLE "CITY CATEGORY";
VBAR City_Category;
RUN;
/*INFERENCE:*/
/* The people in Mid-town Area purchased high during Black Friday*/
/* The people in Small town purchase low when compared to Metropolitan Area people.*/
title;
/*COLUMN OCCUPATION */
PROC UNIVARIATE DATA=SASBF.BFCLEANDATA;
   VAR Occupation;
RUN;
PROC FREQ DATA=SASBF.BFCLEANDATA;
  TABLES Occupation / out=FreqTable;
RUN;
PROC SGPLOT DATA=SASBF.BFCLEANDATA;
TITLE"OCCUPATION";
VBAR Occupation;
RUN;
TITLE;
/*INFERENCE:*/
/*The top 5 Occupations are.,*/
/*Sales ,Executive/Managerial*/
/*Thirdly, Healthcare Professional followed by Professional; */
/*Fifth place is Maufacturing*/
PROC CORR DATA=SASBF.BlackFriday PLOTS=MATRIX(HISTOGRAM);
RUN;
TITLE;
*========================================;
*----- BIVARIATE ANALYSIS----------------;
*========================================;
/*RELATIONSHIP BETWEEN GENDER AND PURCHASE*/
PROC SGPLOT DATA=SASBF.BFCLEANDATA;
TITLE "RELATIONSHIP BETWEEN GENDER AND PURCHASE";
HBOX Purchase/CATEGORY=Gender;
RUN;
/*INFERENCE:*/
/*Male are purchasing more when compared to Females.*/
/*The Total Purchase made by Male and Female are less than $25,000*/
/*The Total Purchase of Male are in higher range in between $20,000 - $25,000 */

/*RELATIONSHIP BETWEEN AGE AND PURCHASE*/
TITLE "RELATIONSHIP BETWEEN AGE AND PURCHASE";
PROC SGPLOT DATA=SASBF.BFCLEANDATA;
   VBOX PURCHASE / GROUP= AGE;
RUN;
PROC SQL;
	CREATE TABLE SASBF.NO_OF_PRODUCTS_BY_AGE AS
	SELECT SUM(PURCHASE) AS TOTAL_PURCHASE,AGE  FROM SASBF.BFCLEANDATA
	GROUP BY AGE;
QUIT;

proc sgplot data=SASBF.NO_OF_PRODUCTS_BY_AGE;
hbox total_purchase / group=age;
run;
/*Age vs. Count of Product*/
proc sgplot data=SASBF.NO_OF_PRODUCTS_BY_AGE;
   SCATTER x=age y=TOTAL_PURCHASE  / datalabel;
   reg x=age y=TOTAL_PURCHASE / lineattrs=(color=red pattern=dash);
   xaxis label='Age';
   yaxis label='TOTAL PURCHASE';
   title 'Age vs. TOTAL Product';
run;

/*INFERENCE*/
/*The Age group 26-35 have purchased most during Black Friday*/
/*Middle age group 26-35, 36-45 have purchased more*/
/*The Least Purchase was made by age group 0-17 */

/*RELATIONSHIP BETWEEN PURCHASE AND OCCUPATION*/
TITLE "RELATIONSHIP BETWEEN PURCHASE  AND OCCUPATION";
PROC SGPLOT DATA=SASBF.BFCLEANDATA;
   VBOX PURCHASE / GROUP= OCCUPATION;
RUN;
/*INFERENCE*/
/**/
/*CORRELATION*/
PROC CORR DATA=SASBF.BFCLEANDATA PLOTS=MATRIX(HISTOGRAM);
RUN;
/*No Strong relationship between  variables.*/
/*we have a weak positive correlation Marital Status and Occupation with the correlation co-efficient of 0.02428 p value is <0.0001*/
/*Purchase and Occupation have a weak positive correlation with the correlation co-efficient of 0.02083*/


/*CATEGORICAL VS CATEGORICAL*/
/*CHI-SQUARE AND FISHER*/
PROC CONTENTS DATA =SASBF.BFCLEANDATA;
RUN;
PROC FREQ DATA=SASBF.BFCLEANDATA;
TABLE AGE*CITY_CATEGORY/CHISQ FISHER;
EXACT FISHER /MC;
RUN;
/* the test statistic is 22368.8051 with 12 degrees of freedom, and the p-value is less than 0.0001.This indicates strong evidence that there is an association between the two variables in the contingency table. */
/*The phi coefficient, contingency coefficient, and Cramer's V are measures of association for contingency tables.*/
/*the values are all relatively low, indicating that there is some but not strong association between the two variables.*/
PROC FREQ DATA=SASBF.BFCLEANDATA;
TABLE AGE*DIST_PROD/CHISQ FISHER;
RUN;
/*NOTE: RELATIONSHIP BETWEEN CHISQUARE AND CRAMER'S RULE */
/*0(NO ASSOCIATION) 1(PERFECT ASSOCIATION) -1(PERFECT NEGATIVE ASSOCIATION)*/
PROC FREQ DATA=SASBF.BFCLEANDATA;
TABLE AGE*GENDER/CHISQ FISHER;
exact fisher/mc;
RUN;

PROC FREQ DATA=SASBF.BFCLEANDATA;
TABLE AGE*Product_ID/CHISQ FISHER;
exact fisher/mc;
RUN;

PROC FREQ DATA=SASBF.BFCLEANDATA;
TABLE AGE*Stay_In_Current_City_Years/CHISQ FISHER;
exact fisher/mc;
RUN;

PROC FREQ DATA=SASBF.BFCLEANDATA;
TABLE City_Category*DIST_PROD/CHISQ FISHER;
exact fisher/mc;
RUN;
PROC FREQ DATA=SASBF.BFCLEANDATA;
TABLE City_Category*Gender/CHISQ FISHER;
exact fisher/mc;
RUN;

PROC FREQ DATA=SASBF.BFCLEANDATA;
TABLE City_Category*PRODUCT_ID/CHISQ FISHER;
exact fisher/mc;
RUN;

PROC FREQ DATA=SASBF.BFCLEANDATA;
TABLE CITY_CATEGORY*Stay_In_Current_City_Years/CHISQ FISHER;
exact fisher/mc;
RUN;

PROC FREQ DATA=SASBF.BFCLEANDATA;
TABLE DIST_PROD*GENDER/CHISQ FISHER;
exact fisher/mc;
RUN;

PROC FREQ DATA=SASBF.BFCLEANDATA;
TABLE DIST_PROD*PRODUCT_ID/CHISQ FISHER;
EXACT FISHER/MC;
RUN;

PROC FREQ DATA=SASBF.BFCLEANDATA;
TABLE DIST_PROD*Stay_In_Current_City_Years/CHISQ FISHER;
EXACT FISHER/MC;
RUN;

PROC FREQ DATA=SASBF.BFCLEANDATA;
TABLE GENDER*PRODUCT_ID/CHISQ FISHER;
EXACT FISHER/MC;
RUN;

PROC FREQ DATA=SASBF.BFCLEANDATA;
TABLE GENDER*Stay_In_Current_City_Years/CHISQ FISHER;
exact fisher/mc;
RUN;

PROC FREQ DATA=SASBF.BFCLEANDATA;
TABLE PRODUCT_ID*Stay_In_Current_City_Years/CHISQ FISHER;
EXACT FISHER/MC;
RUN;
PROC CONTENTS DATA=SASBF.BFCLEANDATA;
RUN;

/*ANOVA - CAT VS. CONT*/
/*AGE Vs. PURCHASE*/
PROC ANOVA DATA =SASBF.BFCLEANDATA;
CLASS AGE;
MODEL PURCHASE=AGE;
MEANS AGE / HOVTEST=LEVENE;
RUN;

/*GENDER Vs. PURCHASE*/
/*PROC ANOVA DATA =SASBF.BFCLEANDATA;
CLASS GENDER;
MODEL PURCHASE=GENDER;
MEANS GENDER / HOVTEST=LEVENE;
RUN;

/*STAY_IN_CITY Vs PURCHASE*/
PROC ANOVA DATA=SASBF.BFCLEANDATA;
CLASS Stay_In_Current_City_Years;
MODEL PURCHASE=Stay_In_Current_City_Years;
MEANS Stay_In_Current_City_Years/HOVTEST=LEVENE;
RUN;

/*CITY_CATEGORY Vs PURCHASE*/
PROC ANOVA DATA=SASBF.BFCLEANDATA;
CLASS CITY_CATEGORY;
MODEL PURCHASE=CITY_CATEGORY;
MEANS CITY_CATEGORY/HOVTEST=LEVENE;
RUN;
/*STAY_IN_CITY Vs PURCHASE*/
PROC ANOVA DATA=SASBF.BFCLEANDATA;
CLASS Stay_In_Current_City_Years;
MODEL PURCHASE=Stay_In_Current_City_Years;
MEANS Stay_In_Current_City_Years/HOVTEST=LEVENE;
RUN;
/*STAY_IN_CITY Vs PURCHASE*/
PROC ANOVA DATA=SASBF.BFCLEANDATA;
CLASS Stay_In_Current_City_Years;
MODEL PURCHASE=Stay_In_Current_City_Years;
MEANS Stay_In_Current_City_Years/HOVTEST=LEVENE;
RUN;
/*Purchase Vs Occupation*/
PROC ANOVA DATA=SASBF.BFCLEANDATA;
CLASS occupation;
MODEL PURCHASE=occupation;
MEANS occupation/HOVTEST=LEVENE;
RUN;
title;

/*Purchase Vs Age*/
PROC ANOVA DATA=SASBF.BFCLEANDATA;
CLASS age;
MODEL PURCHASE=age;
MEANS age/HOVTEST=LEVENE;
RUN;

/*Purchase Vs Gender*/
PROC ANOVA DATA=SASBF.BFCLEANDATA;
CLASS Gender;
MODEL PURCHASE=Gender;
MEANS gender/HOVTEST=LEVENE;
RUN;
*============================================;
*----- MULTI-VARIATE ANALYSIS----------------;
*============================================;
/*Distribution of Customers*/
PROC TABULATE DATA=SASBF.BFCLEANDATA;
TITLE 'Customers Distribution across Age, City Category, Gender and  Marital Status';
CLASS AGE CITY_CATEGORY GENDER Marital_Status;
TABLE CITY_CATEGORY*(GENDER ALL), AGE='AGE GROUPS'*(PCTN='% ')
ALL*(N PCTN) Marital_Status;
RUN;

PROC TABULATE DATA=SASBF.BFCLEANDATA;
TITLE 'Customers Distribution across Age, City Category, Gender and  Marital Status';
CLASS AGE  GENDER PURCHASE ;
TABLE GENDER*(GENDER ALL), AGE='AGE GROUPS'*(PCTN='% ') ALL*(N PCTN) pURCHASE;
RUN;

*========================================;
*----- PROBLEM STATEMENT----------------;
*========================================;

/* 1). WHAT IS THE MAXIMUN NUMBER OF PRODUCTS*/
PROC SQL OUTOBS=10;
CREATE TABLE SASBF.MAX_PRODUCT_ID AS
select max(prod_count) as Max_Count_Product,b.Product_ID from(
select count(Product_ID) as prod_count,Product_ID from SASBF.BFCLEANDATA
group by Product_ID)b
group by b.Product_ID,prod_count
order by prod_count desc;
QUIT;

/*VIEW THE OUTPUT*/
PROC PRINT DATA=SASBF.MAX_PRODUCT_ID;
RUN;
 
PROC SGPLOT data=SASBF.MAX_PRODUCT_ID;
 VBAR Product_ID / response=Max_Count_Product datalabel= Max_Count_Product groupdisplay=cluster;
  TITLE 'Top 10 Products';
RUN;
/*INFERENCE:*/
/*The Product_ID P00265242 is highly sold -- People purchase this product 1880 times*/
title;

/* 2). WHICH GENDER MADE A MAXIMUN NUMBER OF TRANSACTIONS */
 PROC GCHART DATA=SASBF.BFCLEANDATA;
 Title "Gender";
 PIE3D GENDER/DISCRETE
 VALUE=INSIDE
 PERCENT=OUTSIDE
 EXPLODE=ALL
 SLICE=OUTSIDE
 RADIUS=20;
 RUN;
 /*INFERENCE:*/
 /*Purchase made by Males are comparitevly high when compared to Females*/

 /* 3).WHICH AGE GROUP PEOPLE MADE THE HIGHEST NUMBER OF TRANSACTIONS*/
  PROC GCHART DATA=SASBF.BFCLEANDATA;
 TITLE "AGE DISTRIBUTION";
 PIE3D age/DISCRETE
 VALUE=INSIDE
 PERCENT=OUTSIDE
 EXPLODE=ALL
 SLICE=OUTSIDE
 RADIUS=20;
 RUN;
 /*INFERENCE:*/
 /*PEOPLE IN AGE GROUP 26-35 ARE TEND TO PURCHASE MORE DURING BLACK FRIDAY*/

/* 4).WHICH CITY PEOPLE ARE MOST LIKELY TO PURCHASE DURING BLACKFRIDAY? */
TITLE "DISTRIBUTION OF CITY ACCROSS THE CUSTOMER";
PROC SGPLOT DATA=SASBF.BFCLEANDATA;
	VBAR City_Category;
RUN;


/*INFERENCE:*/
/*Mid-Town people are most likely to purchased more during blackfriday when copmpared to Metropolitan area and small town*/


/* 5). WHICH CATEGORY OF PRODUCT WAS PURCHASED HIGH IN PRODUCT_CATEGORY_1? */

TITLE "HIGHEST PURCHASE OF PRODUCT CATEGORY_1";
 PROC GCHART DATA=SASBF.BFCLEANDATA;
 PIE3D Product_Category_1/DISCRETE
 VALUE=INSIDE
 PERCENT=OUTSIDE
 EXPLODE=ALL
 SLICE=OUTSIDE
 RADIUS=20;
 RUN;

/*INFERENCE:*/
/*Beauty Products item was purchased high followed by Electronics*/
/*Toys and Games are the third highest*/

 /* 6).WHICH CATEGORY OF PRODUCT WAS PURCHASED HIGH IN PRODUCT_CATEGORY_2*/

 TITLE "HIGHEST PURCHASE OF PRODUCT CATEGORY_2";
 PROC GCHART DATA=SASBF.BFCLEANDATA;
 PIE3D Product_Category_2/DISCRETE
 VALUE=INSIDE
 PERCENT=OUTSIDE
 EXPLODE=ALL
 SLICE=OUTSIDE
 RADIUS=20;
 RUN;

PROC SGPLOT DATA=SASBF.BFCLEANDATA;
HBAR Product_Category_2 ;
RUN;
/*INFERENCE:*/
/*The Category UNKNOWN are purchased most followed by COOKWARE AND BAKEWARE.*/
/*In Product_category_2  Toys&Games is the third highest.*/

/* 7).What is the total purchase by Occupation*/

PROC SQL;
CREATE TABLE SASBF.TotalMoneySpentperOccupation AS
SELECT SUM(PURCHASE) AS TOTAL_MONEY format=dollar12.,OCCUPATION FROM SASBF.BFCLEANDATA
GROUP BY OCCUPATION;
QUIT;
proc sgplot data=SASBF.TotalMoneySpentperOccupation;
   title 'Total Money Spent per Occupation';
   vbar OCCUPATION / response=TOTAL_MONEY datalabel;
   xaxis label='OCCUPATION';
   yaxis label='TOTAL MONEY SPENT';
run;

proc sgplot data=SASBF.TotalMoneySpentperOccupation;
   SCATTER x=OCCUPATION y=TOTAL_MONEY / datalabel;
   REG x=OCCUPATION y=TOTAL_MONEY / lineattrs=(color=red pattern=dash);
   xaxis label='OCCUPATION';
   yaxis label='TOTAL MONEY SPENT';
   title 'Total Money Spent per Occupation';
run;

/*INFERENCE:*/
/*The Occupation is negatively correlated with Total Purchase*/	
/*Top 5 Occupations are  Sales,Executive/Managerial,Health care Professionals,Manufacturing and Administrative */
/*Bottom 3 occupations are Education,Finance,Transportation/Logistics*/

/* 8). What is the Distribution of occupation across the customer*/


PROC SQL;
CREATE TABLE SASBF.CUST_OCCU AS
SELECT COUNT(DISTINCT (USER_ID)) AS USER_COUNT ,OCCUPATION FROM SASBF.BFCLEANDATA
GROUP BY Occupation;
QUIT;
 /*DISTRIBUTION OF OCCUPATION ACROSS THE CUSTOMERS*/
TITLE "DISTRIBUTION OF OCCUPATION ACROSS THE CUSTOMERS";
PROC SGPLOT DATA=SASBF.CUST_OCCU;
	VBAR OCCUPATION / RESPONSE=USER_COUNT datalabel ;
RUN;

TITLE;
/*INFERENCE:*/
/*740 users are in the sales Ocuupation followed by 688 Executive/Managerial Category*/
/*669 users are from Healthcare  and 517 from Professionals. */

/*9). DISTRIBUTION OF CITY CATEGORY ACROSS THE CUSTOMER*/
PROC SQL;
CREATE TABLE SASBF.CUST_CITY AS
SELECT COUNT(DISTINCT (USER_ID)) AS USER_COUNT ,City_category
FROM SASBF.BFCLEANDATA
GROUP BY City_category;
QUIT;
/*DISTRIBUTION OF CITY ACCROSS THE CUSTOMER*/
TITLE "DISTRIBUTION OF CITY ACCROSS THE CUSTOMER";
PROC SGPLOT DATA=SASBF.CUST_CITY;
	VBAR City_category / RESPONSE=USER_COUNT datalabel ;
RUN;

TITLE;
/*INFERENCE:*/
/*The Users 3139 are from Metropolitan Area followed by Mid-town(1707) */

/*10). WHAT ARE THE UNIQUE_ITEMS(TOTAL PER CATEGORY) IN PRODUCT_CATEGORY_1 and Product_category_2*/
PROC SQL;
CREATE TABLE SASBF.NUM_OF_UNIQUE_ITEMS_CAT1 AS
SELECT distinct(product_id) as Product,COUNT(DISTINCT PRODUCT_ID) AS NUM_UNIQUE_PRODUCTS,Product_Category_1
FROM SASBF.BFCLEANDATA
group by Product_Category_1,product_id
;
QUIT;
PROC SQL;
CREATE TABLE test AS
SELECT distinct(product_id) as Product,Product_Category_1,Product_category_2,product_category_3
FROM SASBF.BFCLEANDATA where product_id= 'P00025142'
group by Product_Category_1,Product_category_2,product_id,product_category_3
;
QUIT;
PROC SQL;
CREATE TABLE SASBF.NUM_OF_UNIQUE_ITEMS_CAT2 AS
SELECT COUNT(DISTINCT PRODUCT_ID) AS NUM_UNIQUE_PRODUCTS,Product_Category_2
FROM SASBF.BFCLEANDATA
group by Product_Category_2
;
QUIT;
PROC SGPLOT DATA=SASBF.NUM_OF_UNIQUE_ITEMS_CAT1;
VBAR Product_Category_1 / RESPONSE=NUM_UNIQUE_PRODUCTS datalabel ;
RUN;
/*INFERENCE:*/
/*The 1047 Items are from Toys/Games followed by the 967 Items from Beauty*/
/*The 493 Items from Electronics  -Top 3  */
/*Least 3 are Food, Miscellaneous Product and Gift card*/
PROC SGPLOT DATA=SASBF.NUM_OF_UNIQUE_ITEMS_CAT2;
VBAR Product_Category_2 / RESPONSE=NUM_UNIQUE_PRODUCTS datalabel ;
RUN;

/*11).What is the count of gender based on age group */

PROC SQL;
CREATE TABLE SASBF.GENDER_AGE AS
SELECT AGE,
COUNT(CASE WHEN GENDER='M'  THEN 1 END) AS MALE,
COUNT(CASE WHEN GENDER='F'  THEN 1 END) AS FEMALE FROM SASBF.BFCLEANDATA 
GROUP BY AGE
;
QUIT;
PROC PRINT DATA = SASBF.GENDER_AGE;
RUN;
proc sgplot data=SASBF.GENDER_AGE;
 title 'Count of Gender based on Age';
 vbar AGE / response=MALE stat=mean barwidth=0.8;
 vbar AGE / response=FEMALE stat=mean barwidth=0.5;
run;
/*INFERENCE:*/
/*In every age bracket male population is higher than females*/

/*12) Total purchase made by gender based on Age group*/

PROC SQL;
CREATE TABLE SASBF.PURCHASE_GENDER_AGE AS
SELECT AGE,
sum(CASE WHEN GENDER='M'  THEN Purchase  END) AS  TOTAL_PURCHASE_MALE,
sum(CASE WHEN GENDER='F'  THEN Purchase END) AS TOTAL_PURCHASE_FEMALE 
FROM
SASBF.BFCLEANDATA 
GROUP BY AGE
;
QUIT;
proc sgplot data=SASBF.PURCHASE_GENDER_AGE;
 title 'Total Purchase of Gender based on Age';
 vbar AGE / response=TOTAL_PURCHASE_MALE stat=MEAN barwidth=0.8;
 vbar AGE / response=TOTAL_PURCHASE_FEMALE stat=MEAN barwidth=0.5;
run;

/*INFERENCE:*/
/*In every age bracket purchase made by Male is higher than Female*/

/*Q13. Based on the years of STAY in CITY,calculate the number of people in that age group*/
PROC SQL;
CREATE TABLE SASBF.city_AGE AS
SELECT COUNT(AGE) AS COUNT_AGE_GROUP,Stay_In_Current_City_Years,AGE
FROM
SASBF.BFCLEANDATA 
GROUP BY AGE,Stay_In_Current_City_Years
;
QUIT;
proc sgplot data=SASBF.city_AGE;
   TITLE "AGE VS. STAY_IN_CITY";
   vbar Stay_In_Current_City_Years / response=COUNT_AGE_GROUP group=AGE groupdisplay=cluster;
   xaxis label="STAY_IN_CITY";
   yaxis label="COUNT";
run;
/*INFERENCE:*/
/*Age group 26-35 is high in all the categories of Stay_in_city*/

/*14). Based on the years of STAY in CITY and age group,finding total purchase made by male and female */
PROC SQL;
CREATE TABLE SASBF.STAY_YEARS_GENDER_AGE AS
SELECT AGE,Stay_In_Current_City_Years,
sum(CASE WHEN GENDER='M'  THEN Purchase  END) AS  TOTAL_PURCHASE_MALE,
sum(CASE WHEN GENDER='F'  THEN Purchase END) AS TOTAL_PURCHASE_FEMALE 
FROM
SASBF.BFCLEANDATA 
GROUP BY AGE,Stay_In_Current_City_Years
;
QUIT;
/* Create grouped bar graph */
proc sgplot data=SASBF.STAY_YEARS_GENDER_AGE;
   vbar AGE / response=TOTAL_PURCHASE_MALE group=Stay_In_Current_City_Years 
	groupdisplay=cluster barwidth=0.35;
   vbar AGE / response=TOTAL_PURCHASE_FEMALE group=Stay_In_Current_City_Years 
	groupdisplay=cluster barwidth=0.35;
   keylegend "Stay_In_Current_City_Years";
   TITLE "AGE,GENDR VS. STAY_IN_CITY";
   xaxis label="AGE";
   yaxis label="TOTAL PURCHASE";
run;

/*15).BASED ON STAY_IN_CITY, FIND OUT PEOPLE LIVING IN WHICH CATEGORU TEN TO PURCHASE MORE*/

proc sql;
CREATE TABLE SASBF.STAY_CITY_PURCHASE AS
SELECT Stay_In_Current_City_Years, SUM(PURCHASE) AS TOTAL_PURCHASE
FROM SASBF.BFCLEANDATA
GROUP BY Stay_In_Current_City_Years
;
QUIT;

proc sgplot data=SASBF.STAY_CITY_PURCHASE;
  vbar Stay_In_Current_City_Years / response=TOTAL_PURCHASE
                   /* Choose the color of the bars */
                   fillattrs=(color=yellow);
                   /* Add a title to the chart */
                   /* Add labels to the axes */
  xaxis label='Stay_in_city';
  yaxis label='Total Purchase';
  TITLE "STAY_IN_CITY Vs. TOTAL PURCHASE";
run;

/*INFERENCE:*/
/*We can say the poeple who are relatively new in the city will purchase more during BlackFriday sale
to setup their new house or etc..*/

/*16. Which COUNT OF product CATEGORY 1 is bought by which gender*/

PROC SQL;
CREATE TABLE SASBF.GENDER_PRODUCT1 AS
SELECT PRODUCT_CATEGORY_1 ,COUNT(PRODUCT_CATEGORY_1) AS COUNT_PRODUCT_CAT1,GENDER
FROM SASBF.BFCLEANDATA
GROUP BY PRODUCT_CATEGORY_1,GENDER
;
QUIT;
proc sgplot data=SASBF.GENDER_PRODUCT1;
   vbar PRODUCT_CATEGORY_1 / response=COUNT_PRODUCT_CAT1 group=GENDER groupdisplay=cluster;
   xaxis label="PRODUCT_CATEGORY_1";
   yaxis label="Count";
   title "Gender Vs. Product_category_1";
run;

/*INFERENCE:*/
/*Male purchased more in Product_category_1 compared to Female*/

/*17. Which COUNT OF product CATEGORY 2 is bought by which gender*/
PROC SQL;
CREATE TABLE SASBF.GENDER_PRODUCT2 AS
SELECT PRODUCT_CATEGORY_2 ,COUNT(PRODUCT_CATEGORY_2) AS COUNT_PRODUCT_CAT2,GENDER FROM SASBF.BFCLEANDATA
GROUP BY PRODUCT_CATEGORY_2,GENDER;
QUIT;
proc sgplot data=SASBF.GENDER_PRODUCT2;
   vbar PRODUCT_CATEGORY_2 / response=COUNT_PRODUCT_CAT2 group=GENDER groupdisplay=cluster;
   xaxis label="PRODUCT_CATEGORY_2";
   yaxis label="Count";
run;

/*INFERENCE:*/
/*Male purchased more in Product_category_2 compared to Female*/

/*18. Which COUNT OF product CATEGORY 2 is bought by which gender*/
PROC SQL;
CREATE TABLE SASBF.GENDER_PRODUCT3 AS
SELECT PRODUCT_CATEGORY_3 ,COUNT(PRODUCT_CATEGORY_3) AS COUNT_PRODUCT_CAT3,GENDER FROM SASBF.BFCLEANDATA
GROUP BY PRODUCT_CATEGORY_3,GENDER;
QUIT;

proc sgplot data=SASBF.GENDER_PRODUCT3;
   vbar PRODUCT_CATEGORY_3 / response=COUNT_PRODUCT_CAT3 group=GENDER groupdisplay=cluster;
   xaxis label="PRODUCT_CATEGORY_3";
   yaxis label="Count";
run;

/*INFERENCE:*/
/*Male purchased more in Product_category_3 compared to Female*/

/*19. Which COUNT OF product CATEGORY 1 is bought by which gender*/
PROC SQL;
CREATE TABLE SASBF.GENDER_PRODUCT1_PURCHASE AS
SELECT PRODUCT_CATEGORY_1 ,COUNT(PRODUCT_CATEGORY_1) AS COUNT_PRODUCT_CAT1,GENDER ,SUM(PURCHASE) AS TOTAL_PURCHASE FORMAT = DOLLAR12.
FROM SASBF.BFCLEANDATA
GROUP BY PRODUCT_CATEGORY_1,GENDER
;
QUIT;
proc sgplot data=SASBF.GENDER_PRODUCT1_PURCHASE;
   Hbar PRODUCT_CATEGORY_1 / response=COUNT_PRODUCT_CAT1 group=GENDER DATALABELFITPOLICY=NONE datalabel= TOTAL_PURCHASE groupdisplay=cluster;
   xaxis label="PRODUCT_CATEGORY_1";
   yaxis label="Count";
run;
/*20. Which COUNT OF product CATEGORY 2 is bought by which gender*/
PROC SQL;
CREATE TABLE SASBF.GENDER_PRODUCT2_PURCHASE AS
SELECT PRODUCT_CATEGORY_2 ,COUNT(PRODUCT_CATEGORY_2) AS COUNT_PRODUCT_CAT2,GENDER ,SUM(PURCHASE) AS TOTAL_PURCHASE FORMAT = DOLLAR12.
FROM SASBF.BFCLEANDATA
GROUP BY PRODUCT_CATEGORY_2,GENDER
;
QUIT;

proc sgplot data=SASBF.GENDER_PRODUCT2_PURCHASE;
   hbar PRODUCT_CATEGORY_2/ response=COUNT_PRODUCT_CAT2 
	group=GENDER datalabel= TOTAL_PURCHASE DATALABELFITPOLICY=NONE groupdisplay=cluster;
   xaxis label="PRODUCT_CATEGORY_2";
   yaxis label="Count";
run;
/*21. Which COUNT OF product CATEGORY 3 is bought by which gender*/
PROC SQL;
CREATE TABLE SASBF.GENDER_PRODUCT3_PURCHASE AS
SELECT PRODUCT_CATEGORY_3 ,COUNT(PRODUCT_CATEGORY_3) AS COUNT_PRODUCT_CAT3,GENDER ,SUM(PURCHASE) AS TOTAL_PURCHASE FORMAT = DOLLAR12.
FROM SASBF.BFCLEANDATA
GROUP BY PRODUCT_CATEGORY_3,GENDER
;
QUIT;
proc sgplot data=SASBF.GENDER_PRODUCT3_PURCHASE;
   vbar PRODUCT_CATEGORY_3/ response=COUNT_PRODUCT_CAT3 group=GENDER  datalabel= TOTAL_PURCHASE groupdisplay=cluster;
   xaxis label="PRODUCT_CATEGORY_3";
   yaxis label="Count";
run;
/*22 Which age group has purchase which product most*/
PROC SQL;
CREATE TABLE SASBF.Product_AGE AS
SELECT AGE,Product_category_1,
Product_category_2,Product_category_3,Sum(Purchase) as Total_purchase
FROM SASBF.BFCLEANDATA 
GROUP BY AGE,Product_category_1,Product_category_2,Product_category_3
;
QUIT;

proc sgplot data=SASBF.Product_AGE;
   scatter x=Product_category_1 y=Product_category_2 / markerattrs=(symbol=circlefilled);
   scatter x=Product_category_3 y=Total_Purchase / markerattrs=(symbol=squarefilled);
   xaxis label="Variable 1 and 3";
   yaxis label="Variable 2 and 4";
   keylegend / title="Variable 5";
run;

/*23 Martial Status Analysis according to age bracket*/
PROC SQL;
CREATE TABLE SASBF.MARITAL_STATUS_AGE AS
SELECT AGE,MARITAL_STATUS,count(Age) as Age_group_count FROM SASBF.BFCLEANDATA
group by  AGE,MARITAL_STATUS;
QUIT;

/*Inference */
/*Within age range of 26-35 Single people are more than marride people*/
proc sgplot data=SASBF.MARITAL_STATUS_AGE;
   vbar MARITAL_STATUS/ response=Age_group_count group=AGE  datalabel= Age_group_count groupdisplay=cluster;
   xaxis label="MARITAL_STATUS";
   yaxis label="Count";
run;
/*24 Martial Status Analysis according to GENDER AND ITS COUNT*/
PROC SQL;
CREATE TABLE SASBF.MARITAL_STATUS_GENDER AS
SELECT GENDER,MARITAL_STATUS,count(GENDER) as GENDER_count
FROM SASBF.BFCLEANDATA
group by  GENDER,MARITAL_STATUS;
QUIT;
/*Inference */
/*WE CAN SAY THAT MALE */
proc sgplot data=SASBF.MARITAL_STATUS_GENDER;
   vbar MARITAL_STATUS/ response=GENDER_count group=GENDER  datalabel= GENDER_count groupdisplay=cluster;
   xaxis label="MARITAL_STATUS";
   yaxis label="Count";
run;
/*25.Who is purchasing more products single or married*/
PROC SQL;
CREATE TABLE SASBF.MARITAL_STATUS_PURCHASE AS
SELECT MARITAL_STATUS,SUM(purchase)  as TOTAL_PURCHASE FORMAT = DOLLAR12.
FROM 
SASBF.BFCLEANDATA
group by  MARITAL_STATUS;
QUIT;
/*ANALYSIS*/
/*SINGLE ARE PURCHASE MORE THAN MARRIED*/
proc sgplot data=SASBF.MARITAL_STATUS_PURCHASE;
   vbar MARITAL_STATUS/ response=TOTAL_PURCHASE group=MARITAL_STATUS  datalabel= TOTAL_PURCHASE groupdisplay=cluster;
   xaxis label="MARITAL_STATUS";
   yaxis label="Count";
run;

/*26 WHICH PRODUCT_CATEGORY_1 IS POPULAR AMONG SINGLES AND MARRIED*/

PROC SQL;
CREATE TABLE SASBF.MARITAL_STATUS_PRODUCT AS
SELECT MARITAL_STATUS,PRODUCT_CATEGORY_1,COUNT(PRODUCT_CATEGORY_1)  as COUNT_PRODUCT
FROM 
SASBF.BFCLEANDATA
group by  MARITAL_STATUS,PRODUCT_CATEGORY_1;
QUIT;
/*SINGLES ARE BUYING PRODUCT 'Beauty Products' MORE AND EVEN THE MARRIED ARE BUYING PRODUCT 5 MOST*/
proc sgplot data=SASBF.MARITAL_STATUS_PRODUCT;
   vbar MARITAL_STATUS/ response=COUNT_PRODUCT group=PRODUCT_CATEGORY_1  datalabel= COUNT_PRODUCT groupdisplay=cluster;
   xaxis label="MARITAL_STATUS";
   yaxis label="Count";
run;
/*27 WHICH SUB PRODUCT_CATEGORY_2 IS POPULAR AMONG SINGLES AND MARRIED*/

PROC SQL;
CREATE TABLE SASBF.MARITAL_STATUS_PRODUCTS AS
SELECT MARITAL_STATUS,PRODUCT_CATEGORY_2,COUNT(PRODUCT_CATEGORY_2)  as COUNT_PRODUCT_2,
PRODUCT_CATEGORY_3,COUNT(PRODUCT_CATEGORY_3)  as COUNT_PRODUCT_3
FROM 
SASBF.BFCLEANDATA
group by  MARITAL_STATUS,PRODUCT_CATEGORY_2 ,PRODUCT_CATEGORY_3;
QUIT;
/*SINGLES ARE BUYING PRODUCT 'Beauty Products' MORE AND EVEN THE MARRIED ARE BUYING PRODUCT 5 MOST*/
proc sgplot data=SASBF.MARITAL_STATUS_PRODUCTS;
   vbar MARITAL_STATUS/ response=COUNT_PRODUCT_2 group=PRODUCT_CATEGORY_2  datalabel= COUNT_PRODUCT_2 groupdisplay=cluster;
   xaxis label="MARITAL_STATUS";
   yaxis label="Count";
run;
/*28 WHICH PRODUCTS TOGETHER IS POPULAR AMONG SINGLES AND MARRIED*/

PROC SQL;
CREATE TABLE SASBF.MARITAL_STATUS_bOTHPRODUCTS AS
SELECT MARITAL_STATUS,PRODUCTS,COUNT(PRODUCTS) AS COUNT_PRODUCTS FROM(
SELECT MARITAL_STATUS,CATS(PRODUCT_CATEGORY_1, '-', PRODUCT_CATEGORY_2 ) as PRODUCTS
FROM 
SASBF.BFCLEANDATA)A
group by  MARITAL_STATUS,PRODUCTS ;/*PRODUCT_CATEGORY_3*/
QUIT;

proc sgplot data=SASBF.MARITAL_STATUS_bOTHPRODUCTS;
   hbar MARITAL_STATUS/ response=COUNT_PRODUCTS group=PRODUCTS  datalabel= PRODUCTS groupdisplay=cluster;
   xaxis label="MARITAL_STATUS";
   yaxis label="Count";
run;
PROC SQL;
CREATE TABLE SASBF.MARITAL_STATUS_PRODUCT2_3 AS
SELECT MARITAL_STATUS,Dist_Prod,Count(Dist_Prod ) as count_PRODUCTS
FROM 
SASBF.BFCLEANDATA
group by  MARITAL_STATUS,Dist_Prod ;
QUIT;

/*************************************************/
/****************LINEAR REGRESSION****************/
/*************************************************/
ods graphics on;
proc reg data=SASBF.BlackFriday (obs=1000);
model Purchase =  Occupation Product_Category_1 Product_Category_2 Product_Category_3;
run;
ODS GRAPHICS OFF;

ods graphics on;
proc glm data=SASBF.BlackFriday;
model Purchase =  Occupation Product_Category_1 Product_Category_2 Product_Category_3;
quit;
ODS GRAPHICS OFF;

proc reg data=SASBF.BlackFriday;
model Purchase =  Occupation Product_Category_1 Product_Category_2 Product_Category_3;
output out=SASBF.reg_model p=prediction;
run;

/*****LINEAR REGRESSION ANALYSIS****/
/* PURCHASE Vs OCCUPATION*/
proc sgplot data=SASBF.BlackFriday;
  title 'Black Friday: Purchase vs. Occupation';
  scatter x=Occupation y=Purchase / markerattrs=(symbol=circlefilled size=8);
  reg x=Occupation y=Purchase / lineattrs=(color=blue thickness=2);
  xaxis label='Occupation';
  yaxis label='Purchase';
run;
/* PURCHASE Vs Product_Category_1*/
proc sgplot data=SASBF.BlackFriday;
  title 'Black Friday: Purchase vs. PRODUCT CATEGORY 1';
  scatter x=Product_Category_1 y=Purchase / markerattrs=(symbol=circlefilled size=8);
  reg x=Product_Category_1 y=Purchase / lineattrs=(color=blue thickness=2);
  xaxis label='Product_Category_1';
  yaxis label='Purchase';
run;
/* PURCHASE Vs Product_Category_2*/
proc sgplot data=SASBF.BlackFriday;
  title 'Black Friday: Purchase vs. PRODUCT CATEGORY 2';
  scatter x=Product_Category_2 y=Purchase / markerattrs=(symbol=circlefilled size=8);
  reg x=Product_Category_2 y=Purchase / lineattrs=(color=blue thickness=2);
  xaxis label='Product_Category_2';
  yaxis label='Purchase';
run;
/* PURCHASE Vs Product_Category_3*/
proc sgplot data=SASBF.BlackFriday;
  title 'Black Friday: Purchase vs. PRODUCT CATEGORY 3';
  scatter x=Product_Category_3 y=Purchase / markerattrs=(symbol=circlefilled size=8);
  reg x=Product_Category_3 y=Purchase / lineattrs=(color=blue thickness=2);
  xaxis label='Product_Category_3';
  yaxis label='Purchase';
run;
/* PURCHASE Vs stay_in_city*/
proc sgplot data=SASBF.BlackFriday;
  title 'Black Friday: Purchase vs. Stay_In_Current_City_Years';
  scatter x=Stay_In_Current_City_Years y=Purchase / markerattrs=(symbol=circlefilled size=8);
  reg x=Stay_In_Current_City_Years y=Purchase / lineattrs=(color=blue thickness=2);
  xaxis label='Stay_In_Current_City_Years';
  yaxis label='Purchase';
run;

/*SPLITING THE DATA*/
/* Load the Black Friday dataset */
data sasbf.blackfriday;
  set sasbf.blackfriday;
  if Purchase > 0 then Purchase_Yes = 1;
  else Purchase_Yes = 0;
run;
/* Split the data into a training set and a testing set */
proc surveyselect data=sasbf.blackfriday out=training method=srs
  sampsize=5000 seed=123;
run;

data testing;
  set sasbf.blackfriday;
  if N > 5000 then output;
run;


/* Split the dataset into a training set and a validation set */
data bf_train bf_valid;
  set sasbf.blackfriday;
  if mod(N, 5) = 0 then output bf_valid;
  else output bf_train;
run;

/* Build the regression model using the training set */

proc reg data=bf_train;
  model Purchase =Occupation Marital_Status  Product_Category_1 Product_Category_2 Product_Category_3 / selection=stepwise;
run;

/* Evaluate the accuracy of the model using the validation set */
proc reg data=bf_valid;
  model Purchase =Occupation Marital_Status  Product_Category_1 Product_Category_2 Product_Category_3;
  output out=predicted_values predicted=target_var_resid;
run;
/* Calculate the accuracy metrics */
proc means data=predicted_values;
  var target_var_resid;
  output out=accuracy_metrics rmse=rmse_value mae=mae_value rsq=rsq_value;
run;


/* Print the accuracy metrics */
proc print data=accuracy_metrics;
  var rmse_value mae_value rsq_value;
run;

proc hpsplit data=SASBF.BLACKFRIDAY cvmethod=random(10) seed=123   
cvmodelfit plots(only)=cvcc;      
CLASS AGE CITY_CATEGORY GENDER ;    
model PURCHASE =AGE CITY_CATEGORY GENDER  OCCUPATION Marital_Status PRODUCT_CATEGORY_1 PRODUCT_CATEGORY_2 PRODUCT_CATEGORY_3 ;  
grow variance; 
run; 
proc hpsplit data=SASBF.BLACKFRIDAY
      cvmethod=random(10) seed=123
      cvmodelfit plots(only)=cvcc;
    /* assignmissing=mean; /handle missing values by imputing mean/
      class AGE CITY_CATEGORY GENDER ;
      model PURCHASE = AGE CITY_CATEGORY GENDER MARITAL_STATUS OCCUPATION MARITAL_STATUS PRODUCT_CATEGORY_1
            PRODUCT_CATEGORY_2 PRODUCT_CATEGORY_3;
      grow variance; /use variance criterion/
run;
