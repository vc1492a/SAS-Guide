	/* This is a SAS Guide. */
	
	/* Note: this is not intended as a direct replacement for formal instruction/study of SAS. */
	
	/* SET UP */
	/* First you need to specify a location and name for your new library. */
	
%let path=FILEPATH;
libname libref "&path"; 

	/* A little hint. You may want to clear the log prior to running code for easy debugging. */
	
dm "clear log";

	/* Or you may want to also clear the reporting window. */
	
ods html close;
ods html;

	/* COMMENTING */

	/* There are two formats for commenting code in sas, block comments (such as this one) and comment statements.
	Comment statements begin with an asterisk (*) and end in a semicolon (;). Comment statements can begin in columns 1 and 2,
	but you should avoid putting block comments in the first two columns of your SAS programs. */
	
	/* ACCESSING DATA */
	
	/* SAS uses two-level data set names, such as work.newsalesemps. The libref (library) comes first, with the dataset name
	second, separated by a period. */
	
data libref.dataset;
	set newlibref.newdataset;
run;

	/* To view a library in its entirety, do something like this. */
	
proc contents data=libref._all_;
run;

	/* You can also view the library without descriptions by typing 'nods' after '_ALL_' */

	/* To view a dataset in its entirety, do something like this. */
	
proc print data=libref.dataset;
run;

	/* You can also view the dataset without observation numbers by typing 'noobs' after 'data=orion.country'. Noobs. Haha. */
	
	/* A libref remains in effect until you cancel it, change it, or cancel your SAS session. Be sure to get into the habit of clearing it
	and integrating that into your workflow. */
	
libname libref clear;
	
	/* SAS handles missing values differenly depending on whether a variable is a character or numeric. Missing numeric values
	are indicated by a "." (period), and missing character values are indicated by "" (nothing). */
	
	/* SAS variables must start with a letter or an underscore, but can continue with any combination of numbers, letters, or underscores.
	They can be uppercase, lowercase, or mixed-case. However the variable is first specified is how the variable is shown in reports unless
	an variable alias is assigned (more on this later). */
	
	/* PRODUCING DETAIL REPORTS */
	
	/* Let's say we want to show just a few variables from a dataset in our report. We can do that like this. */
	
proc print data=libref.dataset;
	var variable_1 variable_2 variable_3;
run;

	/* We can also call operators (like sum, mean, etc.) to variables and include that output in our reports. */
	
proc print data=libref.dataset;
	var variable_1 variable_2 variable_3;
	sum variable_1;
run;

	/* The 'where' and 'contains' operators are pretty cool. They allow you to do things like this. */
	
proc print data=libref.dataset;
	var variable_1 variable_2 variable_3;
	where variable_1<2000 and 
		  variable_2 contains 'nyan';
	sum variable_1;
run;

	/* The observation column (obs) is silly if we have a unique identifier for each observation (row) in our dataset, like a
	product ID, user ID, or something similar. We can replace the observation column with a unique identifier like this. */
	
proc print data=libref.dataset;
	id variable_4;
	var variable_1 variable_2 variable_3;
run;

	/* Note that we do not need to specify our new ID variable (variable_4) with our other variables. */
	
	/* Sorting a dataset is important for humans. We are not computers and it helps to have a hierarchical structure to the data we view. 
	SAS will overwrite your current dataset unless you specify a new one. The below code will sort the new dataset in ascending order
	from variable_2. We can also group the output by a variable after sorting. */
	
proc sort data=libref.dataset
	out=newlibref.newdataset;
	by variable_1 ascending variable_2;
run;
	
proc print data=newlibref.newdataset;
	by variable_1; /* remove this line if you don't want to group by a variable and just want to see the new sorting. */
run;

	/* Titles and footnotes are cool. SAS is weird and overwrites previous titles and footnotes in a weird way. 
	Typing title1 and title2 and later typing title1 will rewrite title1 AND title2 with the new title1. Titles and footnotes
	are global. */
	
title1 'SAS is weird';
title2 'but useful, too';
footnote1 'python is preferred';

proc print data=libref.dataset;
	var variable_1 variable_2 variable_3;
run;

	/* So the following would overwrite both title1 and title2 from the previous code. */
	
title1 'New SAS title';
proc print data=libref.otherdataset;
	var variable_1;
run;
	
	/* You should always clear your titles and footnotes after generating your report. Simply include the following after 
	your last 'run;'. */
	
title;
footnote;

	/* FORMATTING DATA VALUES */
	
	/* We can temporarily assign new labels to the variables in our datasets. Since SAS reports always report variables exactly as they 
	are stored in the dataset, it can be helpful to relabel them. Imagine reporting variables from user clicks or something using just
	the standard variable names. That could get gross really fast. You must include 'label' in your proc statement. */
	
proc print data=libref.dataset label noobs;
	where variable_1<2000 and 
	      variable_2 contains 'nyan';
	label variable_1='Number_of_Nyans'
		  variable_2='Number_of_Cats';
	var variable_1 variable_2 variable_3;
run;

	/* SAS has several different types of variable formats, too. Let's do some stuff with that. 
	Placing a number (like 8) and then a period (.) after the variable in question will format that variable according 
	to the formatting rule specified and with the character length you just specified (like 8). Make sure the character length 
	is long enough for the format you'd like to use. */
	
proc print data=libref.dataset label noobs;
	var variable_1 variable_2 variable_3;
	label variable_1='Number_of_Nyans'
		  variable_2='Nyan_Purchase_Date'
		  variable_3='Nyan_Cost';
	format variable_2 mmddyy10. variable_3 dollar8.;
run;

	/* SAS allows you to specify user-defined formats for both character and numerical data, although the process is a little different
	between the two. You can also use tiers to categorize variable entries for better reporting. User-defined character formats are 
	preceded by a dollar sign ($). */
	
proc format;
	value $nyanfmt 'BRN'='Brown_Cat';
				   'WHT'='White_Cat';
				   'ORG'='Orange_Cat';
				   'BLK'='Black_Cat';
				   'GRY'='Gray_Cat';
				   'Other'='Miscoded';
run;

proc print data=libref.dataset label;
	var variable_1 variable_2 variable_3 variable_4;
	label variable_1='Number_of_Nyans'
		  variable_2='Nyan_Purchase_Date'
		  variable_3='Nyan_Cost';
	format variable_2 mmddyy10. variable_3 dollar10. variable_4 $nyanfmt;
run;

	/* Creating user-defined formats for numeric values is similar. Typing 'low' and 'high' in the numeric tiers will enable SAS
	to determine the min and max of the particular variable you are formatting and will assign the appropriate value to the tier. */
	

proc format;
	value tiers low-<10='Tier1'
				10-20='Tier2'
				20<-high='Tier3';
run;

proc print data=libref.dataset label;
	var variable_1 variable_2 variable_3;
	format variable_2 mmddyy10. variable_2 tiers. variable_3 dollar10.;
run;

	/* READING, CREATING, AND WORKING WITH DATASETS */
	
	/* A SAS 'data' step can read SAS data sets, raw data files, and Microsoft Excel spreadsheets. To create a new SAS dataset 
	from an existing dataset, use the 'DATA' step. You still need to run 'proc print' to view the new dataset. */
	
data newlibref.newdataset; /* new dataset */
	set libref.dataset; /* the existing SAS dataset that will be read in as input data */
	where variable_1<2000 and 
	      variable_2 contains 'nyan'; /* subsetting is totally a thing */ 
run;

proc print data=newlibref.newdataset;
run;
	
	/* We will certainly need to compare calendar dates and SAS date values when working in SAS. The way to do this is through a SAS
	date constant, which are written in the following form: "ddmmm<yy>yy'D". The year can be two or four digits. SAS automatically
	converts date constants into SAS date values. */
	
data newlibref.newdataset;
	set libref.dataset;
	where variable_2<'14feb1992'd; /* don't forget the letter d at the end AFTER the quotes */
run;

	/* Let's create a new variable using the assigment statement. This statement can also be used to assign new values. The assignment 
	statement evaluates an expression and assigns the result to a new or existing variable. */
	
data newlibref.newdataset;
	set libref.dataset;
	where variable_2<'14feb1992'd
	      variable_1 between 3 and 9 and
		  variable_4 contains 'BRN';
	coupon=variable_1*.05;
run;

proc print newlibref.newdataset;
	var variable_1 variable_2 variable_5 coupon;
	id variable_5;
run;

	/* Note: set var1 = missing value and set var2 = 10. In SAS, num=var1+var2/2 equals a missing value, not 5. */

	/* You can use the 'drop' and 'keep' statements to, well, drop and keep variables in your data step. They have no effect on the 
	input dataset and only affect the new dataset you create. Additionally, SAS stores the drop and keep variables in the PDV, 
	meaning that they are available for processing even after being dropped (meaning you can create new variables from a 
	variable that you wish to drop later). */
	
data newlibref.newdataset;
	set libref.dataset;
	drop variable_1 variable_4;
run;

	/* or... */
	
data newlibref.newdataset;
	set libref.dataset;
	coupon=variable_1*.05;
	keep variable_2 variable_3 coupon; /* note that we had to include the new variable */
run;
	
	/* Any new variables created in the data step, like coupon above, cannot be used in a where statement that is nested in the data
	step. This is because that variable does not exist in libref.dataset and instead is created and included in newlibref.newdataset. */
	
	/* You can create a new database and keep or drop certain variables from those datasets at the same time. */
	
data newlibref.newdataset_1(keep=variable_1)
	 newlibref.newdataset_2(drop=variable_2);
	 set libref.dataset;
run;

	/* You can also use the drop or keep statements with the set statement, meaning that those variables or not (or are) read. */
	
data newlibref.newdataset;
	set libref.dataset(drop=variable_1);
run;

	/* A working example. */
	
data work.sales work.exec(drop=Manager_ID);
	set orion.employee_organization;
	if Department = 'Sales' then output work.sales;
	else if Department = 'Executives' then output work.exec;
	/* ignore all other Department values */
	drop Department;
run;

proc print data=work.sales (firstobs=6);
run;

proc print data=work.exec (firstobs=2 obs=3);
run;
	
	/* If statements! Highly useful. You can't use where operators (such as between, and, like, etc.) in an if statement. When using the 
	if statement to subset the data step, SAS excludes any observations where the if statement is false. */
	
data newlibref.newdataset;
	set libref.dataset;
	if variable_1>=5;
run;

proc print newlibref.newdataset;
run;

	/* So when should we use a where statement and when should we use an if statement? If you are subsetting data in the proc step,
	you should use a where statement. If you are subsetting data in the data step, then you can use the if AND where statements. However, 
	when you use the where statement in the data step, the where statement must only reference variables in the input dataset. */
	
	/* When using the label statement in the proc step, the labels are temporary. However, using the label statement in a data step assigns
	permanent labels to the variables. You have to include label in the proc print step to show these new labels. You can also use the 
	format statement to permanently apply formats to the values in the new dataset. */
	
data newlibref.newdataset;
	set libref.dataset;
	label variable_1='Number_of_Nyans';
	format variable_2 mmddyy10.;
run;

proc contents newlibref.newdataset;
run;

proc print newlibref.newdataset label;
run;

	/* READING SPREADSHEET AND DATABASE DATA */
	
	/* SAS has many engines used to access data outside of the SAS environment, such as for Excel and Oracle data. If the bitness of
	the SAS environment and the database environment differ (32 bit vs. 64 bit), then the pcfiles engine must be used to access data. 
	Note: if you are using a client application to access SAS on a remote server, you cannot use the SAS/ACCESS pcfiles statement. The 
	next few examples use the SAS windowing environment. */
	
libname libref engine path="%path/excelfile.xls"; /* engine could be pcfiles (for Excel files) or oracle, for example */

proc contents data=libref._all_;
run;

	/* There are additional attributes used for Oracle databases to take username and passwords into account. */
	
libname libref engine user=username pw=password path=path_to_database schema=oracle_schema; /* engine would be oracle in this case */

proc print data=oralib.database; /* note 'oralib' */
run;

	/* SAS imports Excel worksheets with a $ sign included in their name. SAS datasets cannot contain special characters, so we must 
	refer to them in a special way to account for this lapse in programming. Why SAS does not automatically take care of this issue 
	is anyone's guess, but I digress... */
	
proc print data=libref. 'path/to.excelworksheet$'n;
run;

	/* The where statements are also a litte different when working with Excel files. */
	
proc print data=libref. 'excelworksheet$'n;
	where variable_4 ? 'BRN';
run;

	/* To disassociate a libref, do the follwing. */
	
libname libref clear;

	/* Note: when a date value is read from an Excel worksheet, values are automatically converted to a SAS date and the DATE9 format
	is applied to display those values. */

	/* Let's create a SAS dataset from an Excel worksheet. This exercise is similar to the previous examples that used the data step. */
	
data newlibref.newdataset;
	set libref. 'excelworksheet$'n;
	where variable_4 contains 'BRN'; /* subsetting is totally a thing */
	/* you can still create new variables, assign labels, and format variables. */
run;

proc contents data=newlibref.newdataset;
run;

proc print data=newlibref.newdataset; /* remember to include 'label' if you want to use assigned labels. */
run;

libname libref clear;

	/* You can also create a new Excel workbook in SAS and assign data to worksheets. */
	

libname libref excel 'path/to/excelworksheet.xls'; /* engine here is 'excel' */

data new.excelworksheet;
   set sas.dataset;
run;

libname libref clear;

	/* READING RAW DATA FILES */
	
	/* A raw data files can be a text file, csv file, or ASCII file. Fields can be deliminited or arranged in fixed columns. 
	We can use the data step to read raw data. albiet with a few alterations from what we have done previously. SAS reads fields 
	in the order in which they appear in the raw data files, so you cannot skip over fields. The defualt length for ALL variables 
	is 8 characters, regardless of type. */
	
data newlibref.newdataset;
	infile '%path/file.fileformat' dlm=','; /* here you specify the file and fileformat, and also the delimiter used in the raw data */
	input variable_1 $
		  variable_2 $
		  variable_3 $; /* where you describe the arrangement of the data & specify variable names for the new dataset */
run;

	/* We can use the length statement to alter the data step and specify the correct length for certain variables. 
	The length statement must precede the input statement. */
	
data newlibref.newdataset;
	length variable_1 $ variable_2 $ 12 variable_3 $ 5; /* this assigns length 12 to var1 and var 2 and length 5 to var3 */
	infile '%path/file.fileformat' dlm=','; /* here you specify the file and fileformat, and also the delimiter used in the raw data */
	input variable_1 $
		  variable_2 $
		  variable_3 $; /* where you describe the arrangement of the data & specify variable names for the new dataset */
run;

	/* Running the above code on numeric variables will actually cause SAS to read both variable_1 and variable_2 as character 
	variables. If variable_1 is a numeric variable and also has a length of 8 (or something else), it needs to be read in this way. */
	
data newlibref.newdataset;
	length variable_1 8 variable_2 $ 12 variable_3 $ 5; /* this assigns length 12 to var1 and var 2 and length 5 to var3 */
	infile '%path/file.fileformat' dlm=','; 
	input variable_1 $
		  variable_2 $
		  variable_3 $;
run;
	
	/* Date values are non-standard values in SAS, so reading this data requires a bit more work. The code below reads both standard 
	and non-standard data. The colon format causes SAS to read up to the delimiter and also specifies a length. Omitting the colon 
	will cause SAS to continue reading for that specified length, ignoring the delimiter. 
	
	This 'thing' after the variable name is called an informat. All informats use a dollar sign ($) for character formats, followed 
	by the name of the informat, an optional width (e.g. 8), followed by a period (.). */
	
data newlibref.newdataset;
	infile '%path/file.fileformat' dlm=','; 
	input variable_1 :$12. /* note the colon. */
		  variable_2 $
		  variable_3 $; 
run;

	/* An informat, like the above code, is required to read non-standard numeric data. We can use the date. informat to read 
	dates, which are recorded in the ddmmmyy or ddmmmyyyy formats. The mmddyy. informat reads dates as mmddyy or mmddyyyy. */
	
data newlibref.newdataset;
	infile '%path/file.fileformat' dlm=',';
	input date_format_1 :date.
		  date_format_2 :mmddyy.;
run;

	/* Reading instream data requires the use of the datalines statement, which is placed as the last statement in the data step 
	and precedes the instream data. You use a semi-colon (;) after the instream data to indicate the end of the dataline. */
	
data newlibref.newdataset;
	infile datalines dlm=','; /* specify the delimiter like this when working with raw data */
	input variable_1 variable_2 $ variable_3;
	datalines;
	5 02/28/2015 $25;
	3 07/03/2014 $15;
;

proc print newlibref.newdataset;
run;

	/* Validating data is a necessary skill. When loading raw data, missing entries (indicated by consecutive delimiters) will cause
	SAS to 'shift' values of an observation leftward, placing variable values in incorrect columns. Using the DSD option sets the 
	default delimiter to a comma, treats consecutive delimiters as missing values, and enables SAS to read values with embedded 
	delimiters. */
	
data newlibref.newdataset;
	infile '%path/file.fileformat' dsd; /* dsd instead of dlm='delimiter' */
	input date_format_1 :date.
		  date_format_2 :mmddyy.;
run;

proc print newlibref.newdataset;
run;

	/* dsd cannot be used for missing data in the last entry (column) of a raw data file, because the data is not marked with 
	consecutive delimiters. The missover option is what we need. */
	
data newlibref.newdataset;
	infile '%path/file.fileformat' dlm=',' missover; /* missover used here */
	input date_format_1 :date.
		  date_format_2 :mmddyy.;
run;

proc print newlibref.newdataset;
run;

	/* We can also use the @n and +n pointers to help us in reading data. @n moves the pointer to the column n, and +n moves the 
	pointer n positions. Here's an example. */
	
data newlibref.newdataset;
	infile '%path/file.fileformat';
	input @1 variable_1 4.
		  +2 variable_2 $8.;
run;

	/* SAS loads a new record into the input buffer when it encounters an input statement, by default. It is possible to have 
	multiple input statements in one data step. This is useful when reading a raw data file with multiple records per 
	observation and when reading an entire or subset of a raw data file with mixed record types. */
	
data newlibref.newdataset;
	infile '%path/file.fileformat';
	input variable_1 4.;
	input variable_2 $8.;
run;

	/* SAS also makes use of line pointer controls. You can use / to specify which line you would like to load the raw data from. */
	
data newlibref.newdataset;
	infile '%path/file.fileformat';
	input variable_1 $30. / / /* the first / tells SAS to load the second line of raw data. The second / means the third line. */
	input variable_2 8. / /* here, the / tells SAS to load the fourth line of raw data */
run;

	/* The forward slash is known as a relative line pointer control that moves the pointer relative to the line on which it is 
	currently positioned. There is also an absolute line pointer control that moves the pointer to a specific line in a group of 
	lines. */
	
data newlibref.newdataset;
	infile "%path/file.fileformat";
	input #1 variable_1 $40.
		  #3 variable_2 10.
run;

	/* When loading in multiple data types, we have to force the SAS to hold the initial data record in the data buffer. Otherwise, 
	it would use the first data record in checking the conditional statement but would load in the second record into the buffer. 
	This can be acheived using a trailing @ symbol in the initial input statement. */
	
data newlibref.newdataset;
	infile "&path/file.fileformat";
	input variable_1 $4. @6 variable_2 $3. @;
	if variable_2 = 'USA' then
		input @10 variable_1 mmddyy10.
			  @20 variable_3 7.;
	if variable_2 = 'EU' then
		input @10 variable_1 date9.
			  @20 variable_3 commax7.;
run;

	/* Some working examples. */
	
data sales_staff2;
	infile "&path\sales2.dat";
	input @1 Employee_ID 6.
		  @21 Last_Name $18. / /* tells SAS to go to the next line */
		  @1 Job_Title $20.
		  @22 Hire_Date mmddyy10.
		  @33 Salary dollar8. / /* tells SAS to ignore data in the 3rd line */
run;

title 'Sales Staff';
proc print data=sales_staff2;
run;
title;

data US_Sales AU_Sales;
	drop Country;
	infile "&path\sales3.dat"
	input @1 Employee_ID 6.
		  @21 Last_Name $18. 
		  @43 Job_Title $20.;
	input @10 Country $2. @;
	if Country = 'AU' then
		do;
			input @1 Salary commax8.
				  @24 Hire_Date ddmmyy10.;
			output AU_Sales;
		end;
	else if Country = 'US' then
		do;
		  input @1 Salary comma8.
		        @24 Hire_Date mmddyy10.;
		  output US_Sales;
		end;
run;

title 'AU Sales';
proc print data=AU_Sales noobs;
run;

title 'US Sales';
proc print data=US_Sales noobs;
run;
title;

	/* MANIPULATING DATA */
	
	/* We can use the sum function to add numeric values in assignment statements. The arguments must be enclosed by parentheses
	and seperated by commas. The sum function ignores missing values when present. Using the sum function will allow addition 
	even with missing values (e.g. 500 + . = 500, not .), so use it when you can. */
	
data newlibref.newdataset;
	set libref.dataset;
	variable_6 = sum(variable_1, variable_2);
run;

	/* Date functions (year, qtr, month, day, weekday) are highly useful. They manipulate data values and return SAS values 
	that are also easy to understand to a human. To call the current date, you can use: today() or date(). */ 
	
data newlibref.newdataset;
	set libref.dataset;
	variable_6 = sum(variable_1, variable_2);
	variable_7 = month(date_variable);
run;

	/* if/then statements are extremely useful. It's a conditional statement that executes when meeting specific conditions. It's 
	highly useful for conditional processing of data. */
	
data newlibref.newdataset;
	set libref.dataset;
	if variable_1>=5 then
		nyan_count = 5 + 1; /* I am aware that these statements don't make logical sense but the concept is illustrated */
	if variable_4='BRN' then
		brown_cat = 1;
run;

proc print newlibref.newdataset;
run;

	/* if/else statements are even cooler than if/then statements. */
	
data newlibref.newdataset;
	set libref.dataset;
	if variable_1>=5 then
		nyan_count = 5 + 1;
	else if variable_1<5 then
		nyan_count = 5 - 1;
run;

	/* when writing if/then and if/else statements, you can use logical operators (and, or, not, etc.) to create compound 
	conditions. */
	
data newlibref.newdataset;
	set libref.dataset;
	if variable_1>5 or
	   variable_1<4 then
	   nyan_count = 10;
	else nyan_count = 4.5;
run;
	
	/* The upcase function converts all letters in an argument to uppercase. This saves you from writing a conditional if 
	statement if you have data that is stored in both uppercase and lowercase characters. */
	
data newlibref.newdataset;
	set libref.dataset;
	variable_4 = upcase('BRN');
	if variable_4='BRN' then
	   brown_cat = 1;
	else brown_cat = 0;
run;

	/* Do statements allow you to execute multiple statements when a variable meets the condition or conditions 
	specified by an if/else or if/then statement. This can be extremely useful in batch processing or 
	other tasks. */
	
data newlibref.newdataset;
	set libref.dataset;
	if variable_1>5 then
		do;
			nyan_count = 5 + 1;
			cat_count = 1;
		end;
	else if variable_1<5 then
		do;
			nyan_count = 5 - 1;
			cat_count = 0;
		end;
run;

	/* A working example. */
	
data work.lookup;
	set orion.country;
	outdated = 'N';
	output;
	if Country_FormerName ~= '' then /* not equal */
		do;
			Country_Name = Country_FormerName;
			outdated = 'Y';
			output;
		end;
	drop Country_FormerName and Population;
run;

proc print data=work.lookup;
run;

	/* COMBINING SAS DATASETS */
	
	/* Deciding which method is the best for combining datasets involves knowing the contents and the structure 
	of your input datasets. When combining datasets vertically, you need to make sure the datasets have 
	common variables. We can use the data step to combine datasets in SAS. Below is an example of how to 
	combine datasets with common variables. */
	
data newlibref.newdataset;
	set dataset_1 dataset_2; /* the datasets to be combined */
run;

	/* To combine datasets with different variables, we need to do a bit more work and use the rename statement. */
	
data newlibref.newdataset;
	set dataset_1(rename=(old_variable_2=variable_2))
	    dataset_2(rename=(old_variable_1=variable_1));
run;

	/* In many cases, you will want to merge two datasets that contain one or more common variables. This is 
	called match-merging. Types of merges include one-to-one, one-to-many, and non-match merges. Instead of the 
	set statement, we would use the merge statement, which joins observations from two or more SAS datasets. 
	The below code will execute a merge for both one-to-one and one-to-many relatioships between variables. */
	
data newlibref.newdataset;
	merge dataset_1 dataset_2;
	by variable_1; /* variable that datasets will be merged by */
run;
	
	/* You can use the in=variable statement to identify which input datasets contributed to each observation in 
	your output. SAS creates a binary variable where 0=not_included, 1=included. /*
	
data newlibref.newdataset;
	merge dataset_1(in=d1) /* d1 is where SAS stored the binary variable */
		  dataset_2(in=d2); /* d2 is where SAS stored the binary variable */
	by variable_1;
run;

	/* Selecting non-matches from one of the datasets is also pretty straight-forward. */
	
data newlibref.newdataset;
	merge dataset_1(in=d1)
		  dataset_2(in=d2);
	by variable_1;
	if d1=1 and d2=0; /* this will force SAS to include only non-matches present in dataset_1 */
run;

	/* Alternatively, we could change the if statement to include non-matches present in either dataset */
	
data newlibref.newdataset;
	merge dataset_1(in=d1)
		  dataset_2(in=d2);
	by variable_1;
	if d1=1 or d2=0; /* or statement instead of and */
run;

	/* CREATING SUMMARY REPORTS */
	
	/* Your non-analyst boss will want to see this stuff. The proc freq statement can be used to generate 
	frequency tables of your data. /*
	
proc freq data=libref.dataset;
	tables variable_1 variables_2; /* frequency tables to be produced */
	where variable_4='BRN';
run;
	
	/* What if you want to suppress some of the statistics? You can use several options to suppress 
	summary statistics from the frequency table. /nocum suppresses cumulative frequency and /nopercent 
	suppresses the display of all percentages. When specifying multiple options, you seperate them
	with a space. */ 
	
proc freq data=libref.dataset;
	tables variable_1/nocum nopercent variable_2;
	where variable_4='BRN';
run;

	/* Showing all frequencies of a variable in a report is probably not a good idea for numeric variables. 
	We can improve our frequency reporting by using formats. */
	
proc format;
	value tiers low-<10='Tier1'
				10-20='Tier2'
				20<-high='Tier3';
run;

proc freq data=libref.dataset;
	tables variable_1;
	format variable_1 tiers.;
run;

	/* Finding the frequency of a variable by another is pretty straight forward. */

proc sort data=libref.dataset;
		out=sorted_dataset;
	by variable_2;
run;
	
proc freq data=sorted_dataset;
	tables variable_1;
	by variable_2;
run;

	/* Let's create a cross-tabulation table so we can view statistics for each distinct combination of 
	values of the selected variables in one table. To do this, we just specify an asterisk (*) in 
	between the variable names. The first variable specifies the rows and the second specifies the 
	columns. */
	
proc freq data=libref.dataset;
	tables variable_1*variable_2; /* row by column */
run;

	/* You cannot use the nocum option in a cross-tabulation table but you can suppress the percentage 
	data. Other options are /nofreq, /norow, and /nocol. */
	
proc freq data=libref.dataset;
	tables variable_1*variable_2/nopercent; 
run;

	/* We can specify additional options in the tables statement that will alter the formatting of 
	the frequency table. Some of these options are /list and /crosslist. */

proc freq data=libref.dataset;
	tables variable_1*variable_2/list; 
run;

	/* The datasets may include invalid, missing, or duplicate data values. Proc freq can be used to 
	in these scenarios. The below cose identifies duplicate values and displays them at the top of 
	the frequency table. Another option is to use the nlevels option. */
	
proc freq data=libref.dataset order=freq;
	tables variable_1;
run;
	
proc freq data=libref.dataset nlevels;
	tables variable_1;
run;	

	/* Proc means reports the number of non-missing values, the mean, the standard deviation, min, 
	and max of every numeric variable in a dataset. By using the class statement in the proc 
	means step, you can create more granular proc means reports. */
	
proc means libref.dataset;
	var variable_1 variable_2;
	class variable_1 /* these are class variables and are character or numeric with few discrete values */
run;

	/* To specify specific descriptive statistics, you can do the following. */
	
proc means libref.dataset min max sum;
	var variable_1 variable_2;
run;

	/* To specify the number of decimal places in the proc means output, use the maxdec=X option. 
	Additionally, the nmiss option will show the number of observations with missing values for 
	each variable in the dataset. */
	
proc means libref.dataset n nmiss min max sum maxdec=2;
	var variable_1 variable_2;
run;

	/* Proc univariate is useful for detecting outliers in the data. The syntax is very similar to 
	proc means. */
	
proc univariate data=libref.dataset;
	var variable_1 variable_2; /* must be numerical variables */
run;

	/* The SAS output delivery system allows for the distribution of reports in formats other than 
	SAS output, such as a PDF document, Excel spreadsheet, word document, or web page. You can 
	export to multiple destinations in one procedure. */
	
ods fileformat_1 file="path/to/file"; /* file format could be pdf */ 
ods fileformat_2 file="path/to/file"; /* file format could be xml */ 

proc means libref.dataset n nmiss min max sum maxdec=2;
	var variable_1 variable_2;
run;

ods fileformat_1 close;
ods fileformat_2 close;

	/* CONTROLLING INPUT AND OUTPUT */
	
	/* By default, SAS outputs a report only once at the bottom of the data step. We can take control
	of the output, but SAS then will follow your explicit output instructions, showing no output
	at the end of the data step. */
	
data newlibref.newdataset;
	set libref.dataset;
	variable_1 = 1;
	variable_2 = variable_1 * (1 + variable_3);
	output; /* comment out to hide variable_1 output */
	variable_4 = 2;
	variable_5 = variable_4 * (1 + variable_6);
	output;
run;

	/* Note: Any new variables to SAS are re-initialized in the PDV. Existing variables are not 
	re-initialized. The PDV does not re-initialize after each output statement, only in the 
	bottom of the data step. */
	
	/* We may need to write to more than one dataset in a data step. */
	
data newlibref.newdataset_1 newlibref.newdataset_2 newlibref.newdataset_3;
	 set libref.dataset;
	 if variable_1 = '1' then output newlibref.newdataset_1;
	 else if variable_2 = '2' then output newlibref.newdataset_2;
	 else output newlibref.newdataset_3;
run;

	/* Note: typing 'else output' will cause SAS to write to all the datasets. */
	
	/* Specifying multiple data sets in a single output statement is also possible. */
	
data newlibref.newdataset_1 newlibref.newdataset_2 newlibref.newdataset_3;
	set libref.dataset;
	if variable_1 in ('newlibref.newdataset_1','newlibref.newdataset_2') then 
		output newlibref.newdataset_1 newlibref.newdataset_2;
	else output newlibref.newdataset_3;
run;

	/* Below is a working example of creating 3 new datasets based on some conditional statements. */
	
 data work.fast work.slow work.veryslow;
 	set orion.orders;
 	where Order_Type in (2,3);
 	ShipDays = Delivery_Date - Order_Date;
 	if ShipDays < 3 then output work.fast;
 	else if 5<=ShipDays<=7 then output work.slow;
 	else if ShipDays > 7 then output work.veryslow;
 	/* no output if ShipDays are 3 or 4 */
 	drop Employee_ID;
 run;
	
	/* SUMMARIZING DATA */
	
	/* Let's say we want to create a variable that accumulates a running total. This will look 
	something like this. We need to change the default behavior of SAS to do this, using the 
	retain statement. This tells SAS to retain the values of that specific variable and gives 
	you the ability to set an initial value. */
	
data newlibref.newdataset;
	set libref.dataset;
	retain new_variable 0; /* zero is the initial value */
	new_variable = new_variable + variable_1;
run;

	/* What if there is a missing value somewhere in the data when accumulating data? Subsequent 
	values will be missing. There are many ways to address this function. One is to use the sum 
	function. */
	
data newlibref.newdataset;
	set libref.dataset;
	retain new_variable 0;
	new_variable = sum(new_variable, variable_1);
run;
	
	/* Yet another method for doing the same thing. */
	
data newlibref.newdataset;
	set libref.dataset;
	new_variable + variable_1;
run;

	/* In the above case, it will rewrite missing values from variable_1 to 0. */
	
	/* A working example. */
	
data work.mid_q4;
  set orion.order_fact;
  where '01nov2008'd <= Order_Date <= '14dec2008'd;
  retain Num_Orders 0;
  retain Sales2Dte 0;
  Num_Orders = Num_Orders + 1;
  Sales2Dte = Sales2Dte + Total_Retail_Price;
run;

title 'Orders from 01Nov2008 through 14Dec2008';
proc print data=work.mid_q4;
  var Order_ID Order_Date Total_Retail_Price Num_Orders Sales2Dte;
  format Sales2Dte Dollar10.2;
run;
title;

	/* Another working example. */
	
data work.typetotals;
	set orion.order_fact;
	where '01jan2009'd <= order_date <='31dec2009'd;
	retain TotalRetail 0;
	retain TotalCatalog 0;
	retain TotalInternet 0;
	if Order_Type = 1 then
		do;
			TotalRetail = sum(TotalRetail, Quantity);
		end;
	else if Order_Type = 2 then
		do;
			TotalCatalog = sum(TotalCatalog, Quantity);
		end;
	else if Order_Type = 3 then
		do;
			TotalInternet = sum(TotalInternet, Quantity);
		end;
	keep Order_Date Order_ID TotalRetail TotalCatalog TotalInternet;
run;

proc print data=work.typetotals;
run;

	/* What if you want to accumulate totals for a group of data? First we need to 
	sort the data then process it as before. */
	
proc sort data=libref.dataset out = some_sort;
	by variable_1;
run;

data newlibref.newdataset(keep=variable_1 variable_2);
	set some_sort;
	by variable_1;
	if first.variable_1 then variable_2 = 0;
	variable_2 + variable_3;
	if last.variable_1;
run;

	/* What if I wanted to sort with multiple by variables? */
	
proc sort data=libref.dataset out = some_sort;
	by variable_1;
run;	

data newlibref.newdataset(keep=variable_1 variable_2 variable_3);
	set some_sort;
	by variable_1 variable_2;
	if first.variable_1 then
		do;
			variable_2 = 0;
			variable_3 = 0;
		end;
	variable_2 + variable_4;
	variable_3 + 1;
	if last.variable_1;
	putlog /* dumps the PDV into the log */
run;

	/* A working example. */
	
proc sort data=orion.order_summary out=work.sumsort;
	by Customer_ID;
run;

proc print data=work.sumsort;
run;

proc sort data=orion.order_summary out=work.sumsort;
	by Customer_ID;
run;

data work.customers;
	set work.sumsort;
	by Customer_ID;
	if first.Customer_ID then Total_Sales = 0;
	Total_Sales = sum(Total_Sales, Sale_Amt);
	if last.Customer_ID;
	keep Customer_ID Total_Sales;
run;

title 'SAS YAY';
proc print data=work.customers;
	format Total_Sales DOLLAR11.2;
run;
title;

	/* Another example. */
	
proc sort data=orion.order_qtrsum out=work.sort;
	by Customer_ID Order_Qtr;
run;

data work.qtrcustomers;
	set work.sort;
	by Customer_ID Order_Qtr;
	if first.Order_Qtr = 1 then
		do;
			Total_Sales = 0;
			Num_Months = 0;
		end;
	Total_Sales = sum(Total_Sales, Sale_Amt);
	Num_Months + 1;
	if last.Order_Qtr = 1;
	keep Customer_ID Order_Qtr Total_Sales Num_Months;
run;

title 'SAS YAY';
proc print data=work.qtrcustomers;
	format Total_Sales DOLLAR11.2;
run;
title;

	/* DATA TRANSFORMATIONS */
	
	/* You can use functions in the data step statements anywhere that an expression can appear. SAS 
	has both character and numeric functions. When using a variable list in the context of a function, 
	you have to of keyword must precede the variable list. */
	
data newlibref.newdataset;
	set libref.dataset;
	variable_3 = sum(of variable_1 - variable_2);
run;

	/* The substr (substring) function is useful if you want to extract a specific character from the 
	value of a variable and store it in a new variable. */
	
data newlibref.newdataset;
	set libref.dataset;
	variable_3 = substr(variable_1,4,1); /* variable name, starting position, length of substring */
run;

	/* Note that this function extracts and saves (if outputted) substrings as strings, so if the 
	substring is numeric you need to declare it as such after using the substring function. */
	
	/* The length function could also be useful in certain scenarios and is pretty straight-forward. 
	This code finds the length of variable_1 and stores it as variable_2. */
	
data newlibref.newdataset;
	set libref.dataset;
	variable_2 = length(variable_1);
run;

	/* You can nest functions in SAS, so you could nest length inside the substring function. */
	
data newlibref.newdataset;
	set libref.dataset;
	variable_2 = substr(variable_1,length(variable_1),1);
run;

	/* Some working examples. */
	
data work.codes;
	set orion.au_salesforce;
	length FCode1 FCode2 $1. LCode $4.;
	FCode1=lowcase(substr(First_Name,1,1));
	FCode2=lowcase(substr(First_Name,length(First_Name),1));
	LCode=lowcase(substr(Last_Name,1,4));
run;

title 'Substr Example';
proc print data=work.codes;
	var First_Name FCode1 FCode2 Last_Name LCode;
run;
title;

data work.competitors;
	set orion.newcompetitors;
	length Country $2. Store_Code $6.;
	Country = substr(ID,1,2);
	Store_Code = left(substr(ID,3)); /* values justified left */
	if substr(Store_Code,1,1) = '1';
	City = propcase(City);
run;
	
title 'Stuff';
proc print data=work.competitors;
run;
title;

data work.states;
	set orion.contacts;
	keep ID Name Location;
	Location = propcase(zipname(substr(address2,length(address2)-4,5))); /* zipname will return the state assoc. with zip */ 
run;

title 'ZIPS';
proc print data=work.states;
run;
title;

	/* The scan function returns the nth word of a character value. It is used to extract words from a character 
	value when the relative order of words is known, but their starting positions are not. */
	
data newlibref.newdataset;
	set libref.dataset;
	length variable_2 variable_3 $ 15.;
	variable_2 = scan(variable_1,2,','); /* specified a comma (,) as the delimiter */
	variable_3 = scan(variable_1,1,',');
run;

	/* A working example. */
	
data work.names;
	set orion.customers_ex5;
	length New_Name $50
		   FMnames $30
		   Last $30;
	FMnames = scan(Name,2,',');
	Last = propcase(scan(Name,1,','));
	if Gender = "F" then 
		New_Name = catx(' ','Ms.',FMNames,Last);
	else if Gender = "M" then
		New_Name = catx(' ','Mr.',FMNames,Last);
	keep New_Name Gender;
run;

title 'Scan and Concat';
proc print data=work.names;
run;
title;

	/* There are some highly useful concatenation functions in SAS. One is the catx function which removes leading and 
	trailing blanks, inserts delimiters, and returns a concatenated character string. Other concatenation functions 
	are cat (does not remove the leading or trailing blanks), cats (removes the leading and trailing blanks), 
	catt (removes the trailing blanks), and catq (uses a delimiter to seperate items and adds a quotation mark to 
	strings that contain the delimiter). */
	
data work.catexample;
	/* each value has a leading and trailing blank */
	a = ' a- ';
	b = ' b ';
	c = ' c ';
	cat_example = cat(a,b,c);
	catx_example = catx(a,b,c);
	catt_example = catt(a,b,c);
	cats_example = cats(a,b,c);
	catq_example = catq('D','-',a,b,c); /* modifiers, delimiter, strings 1 through n */
run;

proc print data=work.catexample;
run;

	/* The concatentation operator is another way to join character strings. */
	
data newlibref.newdataset;
	set libref.dataset;
	variable_3 = '('!!variable_1!!')' '!!variable_2;
run;

	/* The find function searches a target string for a specified substring. The below code nests a find function 
	in an if statement and replaces that substring if the if condition is satisfied. */
	
data newlibref.newdataset;
	set libref.dataset;
	if find(string,'substring','modifier', start_position) then
		do;
			substr(string, start_position, length) = 'X';
		end;
run;

	/* A modifier can have the value 'I' or 'T'. If this modifier is omitted, the search is case sensitive and 
	trailing blanks are considered. The start_position specifies the position at which the search should start 
	and the direction of the search. A positive value indicates a right search (negative value indicates left). 
	If this option is omitted, the search starts at postion 1 and moves forward. */
	
	/* The tranwrd function replaces or removes all occurances of a given word (or a pattern of characters) 
	within a character string. It does not remove trailing blanks from the target or replacement and the 
	new variable, if not previously specified, has a default length of 200. If the target string is not 
	found in the source, then no replacement occurs. Using this function to replace an existing string with 
	a longer string may cause truncation of the length statement is not used. */
	
data newlibref.newdataset;
	set libref.dataset;
	length new_variable $20.;
	new_variable = tranwrd(source_variable, target_variable, replacement);
run;

	/* Some working examples. */
	
data work.silver work.gold work.platinum;
	set orion.customers_ex5;
	Customer_ID = tranwrd(Customer_ID, '-00-', '-15-');
	if find(Customer_ID,'Silver','I') > 0 then output work.silver;
	if find(Customer_ID,'Gold','I') > 0 then output work.gold;
	if find(Customer_ID,'Platinum','I') > 0 then output work.platinum;
	keep Customer_ID Name Country;
run;

title1 'Find and Tranwrd';
title2 'Silver';
proc print data=work.silver;
run;

title2 'Gold';
proc print data=work.gold;
run;

title2 'Platinum';
proc print data=work.platinum;
run;
title;

data work.split;
	set orion.employee_donations;
	PctLoc = find(Recipients, '%');
	if PctLoc > 0 then
		do;
			Charity = substr(Recipients,1,PctLoc);
			output;
			Charity = substr(Recipients,1,PctLoc + 3);
			output;
		end;
	else
		do;
			Charity = trim(Recipients)!! ' 100%';
			output;
		end;
	keep Charity;
run;

proc print data=work.split;
run;

data work.supplier;
	length Supplier_ID $5. Supplier_Name $30. Country $2.;
	infile 'supply.dat';
	input Supplier_ID $;
	Country = scan(_INFILE_,-1,' ');
	StartCol = find(_INFILE_,' ');
	EndCol = length(_INFILE_)-2;
	/* Everything between the first and last blank is the supplier name */
	Supplier_Name = substr(_INFILE_,StartCol + 1, EndCol - StartCol);
	drop StartCol EndCol;
run;

proc print data=work.supplier;
run;

	/* We may also want to do data transformations on numeric data in SAS. SAS has many functions 
	that we can use to work with numeric data. One function is the round function, which returns 
	a value rounded to the nearest multiple of rounding unit. */
	
data newlibref.newdataset;
	new_variable = round(12.69, 0.25);
	new_variable_2 = round(variable_2, 0.25);
run;

	/* There are some other numeric functions. The ceil function returns the smallest integer 
	greater than or equal to the argument. The floor function returns the greatest integer less 
	than or equal to the argument. The int function returns the integer portion of the argument. */
	
data newlibref.newdataset;
	var_1 = 10.865;
	Ceil_Var = ceil(var_1);
	Floor_Var = floor(var_1);
	Int_Var = floor(var_1);
run;

	/* We need to know how to convert variable types. Data types can be automatically converted by 
	SAS or explicity altered with the input and put functions. The input function alters a variable 
	from character to numeric and the put function alters a numeric variable to a character variable. 
	
	SAS automatically converts a character value to a numeric value when the character value is used in 
	a numeric context, such as assignment to a numeric variable, an arithmetic operation, logical 
	comparison with a numeric value, and a function that takes numeric arguments. The automatic conversion
	uses the w. informat and produces a numeric missing value from a character value that does not conform 
	to standard numeric notation. The where statement does not perform any automatic conversion in 
	comparisons. */
	
data newlibref.newdataset;
	set libref.dataset;
	variable_1b = input(variable_1, 5.); /* source, informat */
run;

	/* SAS converts a numeric value to a character value automatically when the numeric value is used 
	in a character context, such as assignment to a character variable, a concatentation operation, and 
	a function that accepts character arguments. It uses the best12. format and right aligns the 
	character value. */
	
data newlibref.newdataset;
	set libref.dataset;
	variable_1b = put(variable_1,3.); /* source, format */
run;

	/* Note: the cat family of functions converts any numeric argument to a character string by using 
	the best12. format and then removing any leading blanks. No note is written to the log. */
	
	/* A working example. */
	
data shipping_notes;
  set orion.shipped;
  length Comment $ 21;
  Comment = cat('Shipped on ',put(Ship_Date, mmddyy10.));
  Total = Quantity * input(Price,comma7.);
run;

proc print data=shipping_notes noobs;
  format Total dollar7.2;
run;
	
	/* PROCESSING DATA ITERATIVELY */
	
	/* You can use an iterative do statement to process data more efficiently. The values of start, 
	stop, and increment must be numbers or expressions that yield numbers and are established before 
	executing the loop. The increment defaults to one if omitted from the do statement. */
	
data newlibref.newdataset(drop=i);
	variable_1 = 5000;
	variable_2 = 0.045;
	do i=1 to 20;
		variable_3 + (variable_3 * variable_1) * variable_2;
	end;
run;

	/* When working with item lists, the do loop is executed once for each item in the list. The list 
	must be comma seperated. */
	
data newlibref.newdataset(drop = i month odd);
	do month = 'Jan','Feb','Mar','Apr'; /* character constraints */
		...
	end;
	do odd = 1, 3, 5, 7, 9; /* numeric constraints */
		...
	end;
	do i = var_1, var_2, var_3; /* variables */
		...
	end;
run;

	/* A working example. */
	
data future_expenses;
   drop start stop; 
   Wages=12874000;
   Retire=1765000;
   Medical=649000;
   start=year(today())+1;
   stop=start+9;
  /* do loop here */
   do year = start to stop;
      wages = wages * 1.06;
	  retire = retire * 1.014;
	  medical = medical * 1.095;
	  total_cost = sum(wages, retire, medical);
	  output;
	end;
run;
proc print data=future_expenses;
   format wages retire medical total_cost comma14.2;
   var year wages retire medical total_cost;
run;

	/* Conditional loop statements are super cool! You can use the do until statement or do while 
	statement to write conditional loop statements. The do until statement executes statements in 
	a do loop until a condition is true. The value of the expression is evaluated at the bottom of 
	the loop and the statements in the loop are executed at least once. The do while statement 
	executes statements in a do loop repetitively while a condition is true. The value of the 
	expression is evaluated at the top of the loop, not the bottom as in the do until loop. The 
	statements in the loop never execute if the expression is intially false. */
	
	/* Working examples of the do until and do while loops. */
	
data work.invest;
	do year = 1 to 30 until(capital > 250000);
		capital + 5000;
		capital + (capital * 0.045);
	end;
run;

proc print data=work.invest noobs;
	format capital dollar14.2;
run;

do work.invest;
	do year = 1 to 30 while(capital <= 250000);
		capital + 5000;
		capital + (capital * 0.045);
	end;
run;

proc print data=work.invest noobs;
	format capital dollar14.2;
run;

	/* Nested do loops are also coolio. Below is a working example. It calculates the increase in captital 
	for each quarter for each year. */
	
data work.invest(drop=quarter);
	do year = 1 to 5;
		capital + 5000;
		do quarter = 1 to 4;
			capital + (capital * (0.045 / 4));
		end;
		output;
	end;
run;

proc print data=work.invest noobs;
run;

	/* A couple more examples. */
	
data work.expenses;
	income = 50000000;
	expenses = 38750000;
	income_rate = 0.01;
	expense_rate = 0.02;
	do year = 1 to 30 until (expenses > income);
		income = income * 1.01;
		expenses = expenses * 1.02;
		output;
	end;
run;

proc print data=work.expenses noobs;
run;

data work.expenses;
	income = 50000000;
	expenses = 38750000;
	income_rate = 0.01;
	expense_rate = 0.02;
	do i = 1 to 75;
		income = income * 1.01;
		expenses = expenses * 1.02;
		if expenses > income then leave;
		output;
	end;
run;

proc print data=work.expenses noobs;
run;

	/* Array processing can simplify programs that perform repetitive calculations, create many variables with 
	the same attributes, read data, compare variables, and perform a table lookup. A SAS array is a temporary 
	grouping of SAS variables that are arranged in a particular order and exists only for the duration of the 
	data step. It must contain all numeric or all character variables. SAS arrays are different from arrays in 
	most programming languages in that they are not data structures, just a convenient way of temporarily 
	identifying a group of variables. 
	
	The array statement is a compile-time statement that defines the elements in an array and looks something 
	like this: array contrib{subscript} $ length array-elements. 
	The $ sign indicates that the elements are character elements and isn't needed when working with numeric 
	data. The length statement specifies the length of elements in the array that were not previously 
	assigned a length. */
	
data newlibref.newdataset;
	set libref.dataset;
	keep variable_1 variable_2 - variable_5;
	array contrib{4} variable_2 - variable_5; /* the 4 specifies the number of variables in the array */
	/* alternatively, use an asterisk (*) in place of the 4 to force SAS to count the amount of 
	variables in the array list */
	do i = 1 to 4;
		contrib{i} = contrib{i} * 1.25;
	end;
run;

	/* Some working examples. */
	
data work.discount_sales;
	set orion.orders_midyear;
	discount = 0.05;
	array mon{*} Month1 - Month6;
	do i = 1 to 6;
		mon{i} = mon{i} * (1 - discount);
	end;
	drop i discount;
run;

proc print data=work.discount_sales;
run;

data work.special_offer;
	set orion.orders_midyear;
	three_mo_discount = 0.10;
	total_sales = sum(of Month1 - Month6);
	array mon{*} Month1 - Month3;
	do i = 1 to 3;
		mon{i} = mon{i} * (1 - three_mo_discount);
	end;
	projected_sales = sum(of Month1 - Month6);
	difference = total_sales - projected_sales;
	keep total_sales projected_sales difference;
	format total_sales projected_sales difference dollar20.2;
run;

options nodate nonumber;
proc print data=work.special_offer noobs;
run;

data work.shabam;
	set orion.orders_midyear;
	total_order_amount = 0;
	months_ordered = 0;
	array amt{*} month:; /* the colon tells SAS to continue to the end */
	if dim(amt) < 3 then
		do;
			put 'This shit exited';
			stop;
		end;
	do i = 1 to dim(amt);
		if amt{i} ~= . then months_ordered + 1;
		total_order_amount + amt{i};
	end;
	if total_order_amount > 1000 and months_ordered >= (dim(amt))/2;
	keep customer_ID months_ordered total_order_amount;
run;

proc print data=work.shabam;
	format total_order_amount dollar10.2;
run;

	/* You can pass SAS arrays to other functions, such as sum or dim. */
	
data newlibref.newdataset;
	set libref.dataset;
	arrray val{5:14} variable_5 - variable_14;
	total_1 = sum(of val{*});
	do i = 1 to dim(val);
		val{i} = val{i} * 1.25;
	end;
run;
	
	/* The hbound and lbound functions can be useful. The hbound returns the upper bound of 
	an array while lbound returns the lower bound of an array. */
	
data newlibref.newdataset;
	set libref.dataset;
	arrray val{*} variable_1 - variable_4;
	do i = lbound(val) to hbound(val);
		*process val{i};
	end;
run;

	/* In most cases, the lower bound of an array is 1, but the lbound statement is useful when 
	the lower bound of an array is something other than 1. */
	
	/* You can also create variables with the array statement, both character and numeric. */
	
data newlibref.newdataset;
	set libref.dataset;
	array numeric_array{4}; 
	/* since the variables are not defined SAS creates 4 numeric variables */
	array character_array{4} $ 10;
	/* SAS creates 4 character variables with length 10 */
	format numeric_array1 - numeric_array4 dollar10.2; /* you can format new variables */
end;

	/* Sometimes you may want to create a temporary lookup table, or a list of values to refer 
	to during the data step processing with an initial set of values and the _temporary_ 
	statement. It's pretty straight-forward. */
	
data newlibref.newdataset(drop = i);
	set libref.dataset;
	array contrib{4} qtr1 - qtr4;
	array diff{4};
	array temp{4} _temporary_ (10,20,30,40); /* tag plus intial values */
	do i = 1 to 4;
		diff{i} = sum(contrib{i}, -goal{i}); /* recall sum function ignores missing values */
run;

	/* A working example. */
	
data preferred_cust;
   set orion.orders_midyear;
   array Mon{6} Month1-Month6;
   array target{6} _temporary_ (200,400,300,100,100,200);
   array over{6};
   do i = 1 to 6;
      if mon{i} > target{i} then
	  	 over{i} = mon{i} - target{i};
   end;
   total_over = sum(of over{*});
   if total_over > 500;
   keep Customer_ID Over1-Over6 Total_Over;
run;

proc print data=preferred_cust noobs;
run;