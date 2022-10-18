# Learning Practical Path 


**[WORK IN PROGRESS]**


## Chapter 4 - Cloud PubSub & Cloud Client Libraries (1-3 days)

![Your mission architecture](img/architecture_first_wkf.png)

### The Context
Any file that comes to your bucket has already passed a bunch of tests during the chapter 3, to ensure data conformity. It now needs to be uploaded on a BigQuery data warehouse, then archived in an other Google Cloud Storage bucket. Finally, you will have to trigger the workflow that will apply all the transformation to these raw data and thus defining the transformation pipeline.

All of these actions, like in the chapter 3, will be performed thanks to a Cloud Function.

### The Learning Resources

### Your mission

To insert the data from Google Cloud Storage to BigQuery (TODO 2), you need to :
- Connect to the Cloud Storage client
- Connect to the BigQuery client
- Construct the correct table_id in the well-chosen format (?)
- After constructing the required parameters, use the appropriate function (class more precisely) to realize the configuration of the job that will load the file into BigQuery.
- Then, after constructing the required parameters, use the appropriate method to run the loading job
- After waiting that the job is finished, you can print the numbert of rows loaded in the table

To archive the data in an other bucker (TODO 1), get inspired by what you have done in the previous chapter

To trigger workflow (TODO 3):
- Connect to Cloud Workflows Client
- Create the worflow execution request, using well built parameters.
- ....

(define/explain data conformity ?)
(define data warehouse ? ->chap 3 ?)
(explain workflow ?)
(define cf -> chap 3)


