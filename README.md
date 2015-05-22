# Coursera - Getting and Cleaning Data - Course Project

### Prerequisites
The script `run_analysis.R` expects to have the `UCI HAR DataSet` folder in ./

###Output
When run, the script will output, in ./ a `TIDY.TXT` file which was uploaded as the answer to the first question

###Explanations
I decided to go for a wide tidy data frame.
Each line will have all measurement means for a single subject/activity pair.

There will then be 180 observations (30 subjects x 6 activities)

###High-level view of the script

* Read the Activities IDs and their corresponding names (WALKING, LAYING, ...)
* Read the Features IDs and their corresponding names (all the 561 measures names)
    + For the training set
    + Get all activities IDs for all the observations
    + Get all the Features values for all the observations
    + Get all the subjects IDs for all the observations
    + build a data frame with Subject ID, Activity name, all measures
* For the testing set
    + Same as for training set
* Merge training and test sets into a OneSet
* Build a vector which will contain all the columns to keep (66 measures + 2 columns)
    + Put all columns having mean()
    + Add all columns having std()
    + Shift them as they now start at index 3
    + Add first two columns (Subject and Activity)
* Create a subset of OneSet named OneSubSet which contains all the data we need and not more
* The data frame which will be the final tidy one is creating empty, on the model of the OneSubSet
* Two simple nested for loops will fill it
    + Loop on all subjects
        +Loop on all activities
            + Add to the tidy data frame a new line with the Subject, Activity and the means of all measurement columns
* Use write.table() to output the tidy data frame
