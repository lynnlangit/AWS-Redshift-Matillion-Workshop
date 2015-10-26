# AWS-Redshift-Matillion-Workshop
Scripts, Instructions and Materials for AWS Redshift and Matillion ETL workshop

![Redshift Workshop Diagram](/Redshift-Workshop.png)

This Repo details instructions on how to use these artifacts can be found on my blog post about the AWS re:Invent 2015 
'Build a Data Warehouse in 2 hours using AWS Redshift and AWS Marketplace Big Data Partners'. NOTE: We modified (reduced size and complexity) from the original Matillion instructions, so you will have to carefully read the blog post and modify based on the amount and complexity of source data you wish to load and analyze.

What's here

- AWS Cli install script - 'BuildRedshiftMatillionWorkshop.sh'
- Two Matillion ETL for Redshift jobs - 'Data Load.json' & 'Data Transform.json'
- Tableau workbook for this scenario - 'Redshift Flights.twb'

Here's a simple diagram of the solution architecture, note that we've included use of AWS VPC and AWS IAM User as best practices:

![Redshift Workshop Architecture](/reInvent-Workshop-Architecture.png)

Here's the result - visualized as a Tableau Dashboard

![Redshift Workshop Visualization](/Tableau-Dashboard-Complete.png)


