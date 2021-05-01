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
