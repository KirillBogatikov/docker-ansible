FROM alpine AS semaphore-build

WORKDIR /go/src

RUN git clone https://github.com/semaphoreui/semaphore.git ./semaphore

WORKDIR /go/src/semaphore

ENV OPENTOFU_VERSION=1.7.0
ENV TERRAFORM_VERSION=1.8.2

COPY semaphore/build.sh ./build.sh

RUN chmod +x ./build.sh && ./build.sh

FROM alpine

WORKDIR /temp/sh

COPY ansible/install.sh ./ansible.sh

RUN chmod +x ./ansible.sh && ./ansible.sh

COPY semaphore/install.sh ./semaphore.sh

ENV ANSIBLE_VERSION=9.4.0
ARG ANSIBLE_VENV_PATH=/opt/semaphore/apps/ansible/${ANSIBLE_VERSION}/venv

RUN git clone https://github.com/semaphoreui/semaphore.git semaphore

RUN cp ./semaphore/deployment/docker/server/ansible.cfg /etc/ansible/ansible.cfg && chown 1001:0 /etc/ansible/ansible.cfg
COPY --from=semaphore-build /go/src/semaphore/deployment/docker/server/server-wrapper /usr/local/bin/
COPY --from=semaphore-build /go/src/semaphore/bin/semaphore /usr/local/bin/
COPY --from=semaphore-build /tmp/tofu /usr/local/bin/
COPY --from=semaphore-build /tmp/terraform /usr/local/bin/

RUN chmod +x ./semaphore.sh && ./semaphore.sh

RUN rm -rf /temp/sh

USER 1001

ENV VIRTUAL_ENV=$ANSIBLE_VENV_PATH
ENV PATH =$ANSIBLE_VENV_PATH/bin:$PATH

ENTRYPOINT ["/sbin/tini", "--"]
CMD [ "/usr/local/bin/server-wrapper"]