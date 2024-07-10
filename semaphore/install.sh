#!/bin/bash

apk add --no-cache-U \
  bash curl git gnupg mysql-client openssh-client-default python3 py3-pip rsync sshpass tar tini tzdata unzip wget zip
  rm -rf /var/cache/apk/* && \
  adduser -D -u 1001 -G root semaphore && \
  mkdir -p /tmp/semaphore && \
  mkdir -p /etc/semaphore && \
  mkdir -p /var/lib/semaphore && \
  mkdir -p /opt/semaphore && \
  chown -R semaphore:0 /tmp/semaphore && \
  chown -R semaphore:0 /etc/semaphore && \
  chown -R semaphore:0 /var/lib/semaphore && \
  chown -R semaphore:0 /opt/semaphore && \
  find /usr/lib/python* -iname __pycache__ | xargs rm -rf

chown -R semaphore:0 /usr/local/bin/server-wrapper && \
  chmod +x /usr/local/bin/server-wrapper && \
  chown -R semaphore:0 /usr/local/bin/semaphore && \
  chmod +x /usr/local/bin/semaphore

cd /home/semaphore

apk add --no-cache -U python3-dev build-base openssl-dev libffi-dev cargo && \
  mkdir -p ${ANSIBLE_VENV_PATH} && \
  python3 -m venv ${ANSIBLE_VENV_PATH} --system-site-packages && \
  source ${ANSIBLE_VENV_PATH}/bin/activate && \
  pip3 install --upgrade pip ansible==${ANSIBLE_VERSION} boto3 botocore requests && \
  apk del python3-dev build-base openssl-dev libffi-dev cargo && \
  rm -rf /var/cache/apk/* && \
  find ${ANSIBLE_VENV_PATH} -iname __pycache__ | xargs rm -rf && \
  chown -R semaphore:0 /opt/semaphore