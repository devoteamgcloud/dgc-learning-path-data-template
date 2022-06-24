# Learning Practical Path 


**[WORK IN PROGRESS]**

## Chapter 3 - Cloud Function & Python (1-2 days)

![Your mission architecture](img/architecture_cf.png)

### The Context

Your bucket is now in place and is ready to be used to get the files from Magasin & Cie. 
Of course, a file in a bucket is not really useful so we will then integrate it to get great insights. 

In this context, as soon as a file arrive in the bucket. We want to perform so verification on the file. 
The requirements given to Magasin & Cie to have a pipeline ready to use is to have well formatted & defined files sent to our bucket. 

We asked for the files:
- to be put in a subfolder `input/`.
- to be prefixed with the corresponding data it contains. (`store`, `customer`, `basket`)
- to be suffixed with the sending date as `YYYYMMDD`. (example: `20220301` for March, 1st of 2022.)
- to have the correct extension:
    - CSV for stores and customer files.
    - JSON for the basket files.


### The Learning Resources
### Your mission

Complete the list of Python assertions to check the format of the files. 
It will move the invalid files to the `invalid/` subfolder and leave the correct files to the `input/` subfolder to be inserted right after. 

Then it informs as a PubSub Topic Published for the name of the file to insert (as well as the targeted table where to insert. Do not worry about this part, we will see it in the next Chapter.)

**To test your code, please, use the `__materials__/data/init/` files**


**Bonus:**
Deploy the Cloud Function with the `gcloud` CLI. Go check by yourself for the documentation.


--- 


Then, when you are confortable, you have to create the Terraform deployement of the Cloud Function. 
Go to the Codelab [Deploy Cloud Functions on GCP with Terraform](https://codelabs.devoteamgcloud.com/codelabs/cloud_function_terraform/index.html). 

Redeploy you GCS part removing the comments of the file `iac/cloud_storage.tf`.

