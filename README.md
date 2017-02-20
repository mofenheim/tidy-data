# Coursera Project to create tidy data set


#Overview
The R script called run_analysis.R does the following:

- Downloads and unzips the UCI Hari Datasets.
- Read in the activities file (used for labels) and the datasets
- Merges the data files into two data sets (training and test).
- Merges training and test into one data set.
- Extract only the columns that have mean or standard deviation (std) in the name.
- Appropriately label the activities in the activity column.
- Make the column names more meaningful and tidy.
- Create a second dataset that generates a mean for each variable for subject and activity combination.

#Notes
The following libraries are used:
- library(plyr)
- library(reshape2)
