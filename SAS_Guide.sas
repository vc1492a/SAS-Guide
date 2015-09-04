	/* This is a SAS Guide. */
	
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
	input dataset and only affect the new dataset you create. */
	
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