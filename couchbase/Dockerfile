FROM ubuntu:bionic

ARG VERSION
ARG APPDIR="/opt/couchbase"

ENV APPDIR="${APPDIR}"
ENV DEBIAN_FRONTEND=noninteractive

SHELL ["/bin/bash", "-c"]

RUN apt-get update && \
    apt-get install wget file -y

RUN useradd -s /bin/bash -m -d ${APPDIR} couchbase && \
    chmod 700 ${APPDIR}

USER couchbase
WORKDIR /tmp

RUN wget https://packages.couchbase.com/releases/${VERSION}/couchbase-server-community_${VERSION}-ubuntu18.04_amd64.deb -O couchbase.deb && \
    dpkg-deb -x couchbase.deb ${APPDIR} && \
    rm -f couchbase.deb

WORKDIR ${APPDIR}

RUN rm -rf etc usr lib && \
    mv ./opt/couchbase/* . && \
    rmdir ./opt/couchbase && \
    rmdir ./opt

COPY --chown=couchbase ./entrypoint.sh .

RUN ls -lh

CMD ["/bin/bash", "./entrypoint.sh"]