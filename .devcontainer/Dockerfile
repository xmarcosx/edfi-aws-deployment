# [Choice] Ubuntu version: bionic, focal
ARG VARIANT="focal"
FROM mcr.microsoft.com/vscode/devcontainers/base:0-${VARIANT}

# [Optional] Uncomment this section to install additional OS packages.
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends postgresql-client

RUN wget -O /home/vscode/awscliv2.zip https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip
RUN unzip /home/vscode/awscliv2.zip -d /home/vscode/aws
RUN /home/vscode/aws/aws/install

RUN wget https://releases.hashicorp.com/terraform/0.15.1/terraform_0.15.1_linux_amd64.zip
RUN unzip terraform_0.15.1_linux_amd64.zip && rm terraform_0.15.1_linux_amd64.zip
RUN mv terraform /usr/bin/terraform

RUN apt-get install -y apt-transport-https ca-certificates curl gnupg2 lsb-release \
    && curl -fsSL https://download.docker.com/linux/$(lsb_release -is | tr '[:upper:]' '[:lower:]')/gpg | apt-key add - 2>/dev/null \
    && echo "deb [arch=amd64] https://download.docker.com/linux/$(lsb_release -is | tr '[:upper:]' '[:lower:]') $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list \
    && apt-get update \
    && apt-get install -y docker-ce-cli

WORKDIR /home/vscode

RUN wget -O /home/vscode/edfi.database.admin.nupkg https://pkgs.dev.azure.com/ed-fi-alliance/Ed-Fi-Alliance-OSS/_apis/packaging/feeds/EdFi/nuget/packages/EdFi.Database.Admin.PostgreSQL/versions/5.2.10083/content;
RUN wget -O /home/vscode/edfi.database.security.nupkg https://pkgs.dev.azure.com/ed-fi-alliance/Ed-Fi-Alliance-OSS/_apis/packaging/feeds/EdFi/nuget/packages/EdFi.Database.Security.PostgreSQL/versions/5.2.10103/content;
RUN wget -O /home/vscode/EdFi.Suite3.Ods.Minimal.Template.nupkg https://pkgs.dev.azure.com/ed-fi-alliance/Ed-Fi-Alliance-OSS/_apis/packaging/feeds/EdFi/nuget/packages/EdFi.Suite3.Ods.Minimal.Template.PostgreSQL/versions/5.2.10538/content;
RUN wget -O /home/vscode/EdFi.Suite3.ODS.AdminApp.Database.nupkg https://pkgs.dev.azure.com/ed-fi-alliance/Ed-Fi-Alliance-OSS/_apis/packaging/feeds/EdFi/nuget/packages/EdFi.Suite3.ODS.AdminApp.Database/versions/2.1.1/content

RUN unzip /home/vscode/edfi.database.admin.nupkg -d /home/vscode/edfi-ods-admin;
RUN unzip /home/vscode/edfi.database.security.nupkg -d /home/vscode/edfi-ods-security;
RUN unzip /home/vscode/EdFi.Suite3.Ods.Minimal.Template.nupkg -d /home/vscode/edfi-ods-minimal;
RUN unzip /home/vscode/EdFi.Suite3.ODS.AdminApp.Database.nupkg -d /home/vscode/edfi-ods-admin-scripts;
