FROM ubuntu:24.04

LABEL MAINTAINER="Robin Genz <mail@robingenz.dev>"

ARG NODEJS_VERSION=22

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=en_US.UTF-8

WORKDIR /tmp

RUN apt-get update -q

# General packages
RUN apt-get install -qy \
    apt-utils \
    locales \
    curl \
    git

# Set locale
RUN locale-gen en_US.UTF-8 && update-locale

# Install NodeJS
ENV NODEJS_HOME=/opt/nodejs
RUN mkdir $NODEJS_HOME \
    && curl -sL https://deb.nodesource.com/setup_${NODEJS_VERSION}.x | bash - \
    && apt-get update -q && apt-get install -qy nodejs
ENV NPM_CONFIG_PREFIX=${NODEJS_HOME}/.npm-global
ENV PATH=$PATH:${NODEJS_HOME}/.npm-global/bin

# Clean up
RUN apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/*

WORKDIR /workdir