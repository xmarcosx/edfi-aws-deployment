# terraform-sandbox

This repository is under active development and serves as a proof of concept for using Terraform to deploy the Ed-Fi technology stack on Azure, AWS, and Google Cloud.

This repository is designed to be opened in Visual Studio Code with the Remote - Containers extension.

# Initial configuration
Copy `.env-sample` to `.env` and set the `PGPASSWORD` variable.


## Azure Deployment

```bash

az login;
cd azure;
terraform init;

terraform plan \
    -var="PG_PASSWORD=$PG_PASSWORD";

terraform apply \
    -var="PG_PASSWORD=$PG_PASSWORD";

terraform destroy \
    -var="PG_PASSWORD=$PG_PASSWORD";

```

## AWS Deployment

Create an AWS ECR repository with the name *edfi*. 

```bash

cd aws;
terraform init;

# deploy Ed-Fi ODS

terraform plan \
    -target="postgresql_database.edfi_ods_db" \
    -var="AWS_REGION=$AWS_DEFAULT_REGION" \
    -var="PG_PASSWORD=$PG_PASSWORD";

terraform apply \
    -target="postgresql_database.edfi_ods_db" \
    -var="AWS_REGION=$AWS_DEFAULT_REGION" \
    -var="PG_PASSWORD=$PG_PASSWORD";

terraform destroy \
    -var="AWS_REGION=$AWS_DEFAULT_REGION" \
    -var="PG_PASSWORD=$PG_PASSWORD";

```

## Google Cloud Deployment

### Create Service Account JSON
* Under "Service account", select "New service account".
* Give it any name you like.
* For the Role, choose "Project -> Editor".
* Leave the "Key Type" as JSON.
* Click "Create" to create the key to the base of this repo as `service.json`


```bash

cd google_cloud;
terraform init;

terraform plan \
    -var="GOOGLE_CLOUD_PROJECT=$GOOGLE_CLOUD_PROJECT" \
    -var="PG_PASSWORD=$PG_PASSWORD";

terraform apply \
    -var="GOOGLE_CLOUD_PROJECT=$GOOGLE_CLOUD_PROJECT" \
    -var="PG_PASSWORD=$PG_PASSWORD";

terraform destroy \
    -var="GOOGLE_CLOUD_PROJECT=$GOOGLE_CLOUD_PROJECT" \
    -var="PG_PASSWORD=$PG_PASSWORD";

```