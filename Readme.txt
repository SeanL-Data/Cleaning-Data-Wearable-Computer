
======Code======
run_analysis.R


===How to run===
1. Install reshape2 package (need the melt() function from this package)
2. Set the working directory (line 5) to the directory containing the /UCI HAR Dataset
3. Run


===How it works===
1. Read in data from train, test, and their metadata
2. Join the train and test dataset to their metadata and rename column to more descrptive names
3. Keep only the columns that contain mean() and std()


===Output===
1. Data_Detailed.txt - contains subject_ID, activity_ID, activity, and any column containing mean() or std()
2. Data_Summarized.txt - contains the average of mean() and std() columns by subject and activity