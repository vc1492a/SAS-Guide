	/* This is a SAS Guide. */
	
	/* Note: this is not intended as a direct replacement for formal instruction/study of SAS. */
	
	/* SET UP */
	/* First you need to specify a location and name for your new library. */
	
%let path=FILEPATH;
libname libref "&path"; 

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

	/* an informat, like the above code, is required to read non-standard numeric data. We can use the date. informat to read 
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
	
ods fileformat_1 file="path/to/file";/* file format could be pdf */ 
ods fileformat_2 file="path/to/file";/* file format could be xml */ 

proc means libref.dataset n nmiss min max sum maxdec=2;
	var variable_1 variable_2;
run;

ods fileformat_1 close;
ods fileformat_2 close;