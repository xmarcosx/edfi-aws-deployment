# terraform-sandbox

This repository uses Terraform to deploy various Google Cloud resources.

## Create Service Account JSON
* Under "Service account", select "New service account".
* Give it any name you like.
* For the Role, choose "Project -> Editor".
* Leave the "Key Type" as JSON.
* Click "Create" to create the key to the base of this repo as `service.json`

## Deployment

```bash

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