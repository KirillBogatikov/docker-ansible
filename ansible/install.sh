#!/bin/sh

apk add sudo python3 py3-pip openssl ca-certificates sshpass openssh-client rsync git
apk add --virtual build-dependencies python3-dev libffi-dev musl-dev gcc cargo build-base

rm -rf /usr/lib/python*/EXTERNALLY-MANAGED && \
  pip3 install --upgrade pip wheel && \
  pip3 install --upgrade cryptography cffi && \
  pip3 install ansible-core==2.17.1 ansible==10.1.0 && \
  pip3 install --ignore-installed ansible-lint==24.6.1 && \
  pip3 install mitogen jmespath && \
  pip3 install --upgrade pywinrm

rm -rf /var/cache/apk/* && \
  rm -rf /root/.cache/pip && \
  rm -rf /root/.cargo

mkdir /ansible && \
  mkdir -p /etc/ansible