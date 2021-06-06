# Ed-Fi AWS Deployment

This repository details the process of deploying the Ed-Fi API, ODS, and Admin App on AWS using RDS and App Runner. [Terraform](https://www.terraform.io/) is used to deploy part of the infrastructure.

This repository is under active development and serves as a proof of concept to invoke community discussion around the best way to automate Ed-Fi deployment on AWS.

This repository is designed to be opened in Visual Studio Code with the Remote - Containers extension.

# Initial configuration
Copy `.env-sample` to `.env` and set the various environment variables.


## Ed-Fi ODS

Terraform is used to create a new VPC, necessary security groups, and the AWS RDS instance for the Ed-Fi ODS.

```bash

cd terraform;
terraform init;

terraform plan \
    -var="AWS_REGION=$AWS_DEFAULT_REGION" \
    -var="PG_PASSWORD=$PG_PASSWORD";

terraform apply \
    -var="AWS_REGION=$AWS_DEFAULT_REGION" \
    -var="PG_PASSWORD=$PG_PASSWORD";

# only run below command when you want to remove all resources created
terraform destroy \
    -var="AWS_REGION=$AWS_DEFAULT_REGION" \
    -var="PG_PASSWORD=$PG_PASSWORD";

```


### Seeding ODS with data

After running `terraform apply`, you'll find a PostgreSQL RDS instance with your IP address already whitelisted for access. Upon completion, you'll also be given the RDS instance endpoint URL. To seed the ODS, run the command below:

```bash
cd /workspaces/edfi-aws-deployment;
bash import_ods_data.sh $RDS_ENDPOINT_URL $PG_PASSWORD;

```

## Create a connection to GitHub

1. Sign in to the AWS Management Console, and open the [AWS Developer Tools console](https://console.aws.amazon.com/codesuite/settings/connections)
2. Choose Settings > Connections, and then choose Create connection
3. Select **GitHub** as the provider
4. Set Connection name to *Ed-Fi*
5. Click **Connect to GitHub**
6. Click **Install a new app**
7. Slect the forked repository
8. Click **Connect**

## Ed-Fi API

1. Head to [AWS App Runner](console.aws.amazon.com/apprunner/home) in your AWS console
2. Click *Create an App Runner service*
3. For Repository type, select *Source code repository*
4. Under Connect to GitHub, select *Add new*
5. Set a Connection name (ie. *web-api*)
6. Select your GitHub app from the dropdown
7. Click **Next**


