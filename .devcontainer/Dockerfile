FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    openssh-client \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    unzip \
    git \
    jq \
    apt-utils \
    bash-completion \
    software-properties-common \
    && rm -rf /var/lib/apt/lists/*

RUN curl -sfL https://raw.githubusercontent.com/mc-b/lerncloud/main/services/cloud-cli.sh | bash - 

WORKDIR /workspace
