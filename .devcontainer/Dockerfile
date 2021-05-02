# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.166.1/containers/alpine/.devcontainer/base.Dockerfile

# [Choice] Alpine version: 3.13, 3.12, 3.11, 3.10
ARG VARIANT="3.13"
FROM mcr.microsoft.com/vscode/devcontainers/base:0-alpine-${VARIANT}

# ** [Optional] Uncomment this section to install additional packages. **
# RUN apk update \
#     && apk add --no-cache <your-package-list-here>

RUN wget https://releases.hashicorp.com/terraform/0.15.1/terraform_0.15.1_linux_amd64.zip
RUN unzip terraform_0.15.1_linux_amd64.zip && rm terraform_0.15.1_linux_amd64.zip
RUN mv terraform /usr/bin/terraform

WORKDIR /home/vscode

RUN wget -O /home/vscode/edfi.database.admin.nupkg https://pkgs.dev.azure.com/ed-fi-alliance/Ed-Fi-Alliance-OSS/_apis/packaging/feeds/EdFi/nuget/packages/EdFi.Database.Admin.PostgreSQL/versions/5.2.10083/content;
RUN wget -O /home/vscode/edfi.database.security.nupkg https://pkgs.dev.azure.com/ed-fi-alliance/Ed-Fi-Alliance-OSS/_apis/packaging/feeds/EdFi/nuget/packages/EdFi.Database.Security.PostgreSQL/versions/5.2.10103/content;
RUN wget -O /home/vscode/EdFi.Suite3.Ods.Minimal.Template.nupkg https://pkgs.dev.azure.com/ed-fi-alliance/Ed-Fi-Alliance-OSS/_apis/packaging/feeds/EdFi/nuget/packages/EdFi.Suite3.Ods.Minimal.Template.PostgreSQL/versions/5.2.10538/content;
RUN wget -O /home/vscode/EdFi.Suite3.ODS.AdminApp.Database.nupkg https://pkgs.dev.azure.com/ed-fi-alliance/Ed-Fi-Alliance-OSS/_apis/packaging/feeds/EdFi/nuget/packages/EdFi.Suite3.ODS.AdminApp.Database/versions/2.1.1/content

RUN unzip /home/vscode/edfi.database.admin.nupkg -d /home/vscode/edfi-ods-admin;
RUN unzip /home/vscode/edfi.database.security.nupkg -d /home/vscode/edfi-ods-security;
RUN unzip /home/vscode/EdFi.Suite3.Ods.Minimal.Template.nupkg -d /home/vscode/edfi-ods-minimal;
RUN unzip /home/vscode/EdFi.Suite3.ODS.AdminApp.Database.nupkg -d /home/vscode/ed-fi-ods-admin-scripts;
