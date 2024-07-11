#!/bin/sh

apk add --no-cache -U libc-dev curl nodejs npm gcc zip unzip tar

curl -sL https://taskfile.dev/install.sh | sh

cd /go/src/semaphore || exit

go mod download -x

task deps
task build

wget https://github.com/opentofu/opentofu/releases/download/v${OPENTOFU_VERSION}/tofu_${OPENTOFU_VERSION}_linux_amd64.tar.gz && \
    tar xf tofu_${OPENTOFU_VERSION}_linux_amd64.tar.gz -C /tmp && \
    rm tofu_${OPENTOFU_VERSION}_linux_amd64.tar.gz

curl -O https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /tmp && \
    rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip