	/* This is an SAS Guide. */
	
	/* SET UP */
	/* First you need to specify a location and name for your new library. */
	
%let path=FILEPATH;
libname orion "&path"; 

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
	
proc contents data=libref._ALL_;
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
	where variable_1<2000 and variable_2 contains 'nyan';
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
	where variable_1<2000 and variable_2 contains 'nyan';
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