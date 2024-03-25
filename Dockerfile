# syntax=docker/dockerfile:1.4

FROM ubuntu:latest

RUN apt-get update \
  && apt-get install -y \
    microsocks \
    openconnect \
  && rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /

ENTRYPOINT [ "bash", "entrypoint.sh" ]
