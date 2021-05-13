# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.154.0/containers/ruby/.devcontainer/base.Dockerfile

# [Choice] Ruby version: 2, 2.7, 2.6, 2.5
ARG VARIANT="2"
FROM mcr.microsoft.com/vscode/devcontainers/ruby:0-${VARIANT}

ARG HELM_VERSION="3.5.4"
ARG CT_VERSION=3.3.1
ENV DEBIAN_FRONTEND=noninteractive

COPY Gemfile /tmp/Gemfile

RUN \
  apt-get update \
  && \
  apt-get -y install --no-install-recommends \
    libonig-dev \
    gnupg2 \
    python3-pip \
    python3-setuptools \
  && \
  sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d -b /usr/local/bin \
  && \
  curl -o /tmp/helm.tar.gz "https://get.helm.sh/helm-v${HELM_VERSION}-linux-$(dpkg --print-architecture).tar.gz" \
  && tar xvzf /tmp/helm.tar.gz -C /usr/local/bin --strip-components 1 "linux-$(dpkg --print-architecture)/helm" \
  && chmod +x /usr/local/bin/helm \
  && \
  curl -o /tmp/ct.tar.gz -L "https://github.com/helm/chart-testing/releases/download/v${CT_VERSION}/chart-testing_${CT_VERSION}_linux_$(dpkg --print-architecture).tar.gz" \
  && mkdir -p /etc/ct \
  && tar xvzf /tmp/ct.tar.gz -C /usr/local/bin "ct" \
  && tar xvzf /tmp/ct.tar.gz --strip-components=1 -C /etc/ct "etc/" \
  && chmod +x /usr/local/bin/ct \
  && \
  pip3 install \
    pre-commit \
    yamale \
    yamllint \
  && \
  bundle config set system 'true' \
  && bundle install --gemfile /tmp/Gemfile \
  && \
  rm \
    /tmp/Gemfile \
    /tmp/Gemfile.lock \
    /tmp/helm.tar.gz \
    /tmp/ct.tar.gz
