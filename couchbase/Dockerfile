FROM ubuntu:bionic

ARG VERSION
ARG APPDIR="/opt/app"

ENV APPDIR="${APPDIR}"
ENV DEBIAN_FRONTEND=noninteractive

ENV PATH="/opt/couchbase/${VERSION}/bin:${PATH}"

SHELL ["/bin/bash", "-c"]

RUN apt-get update && \
    apt-get install wget file -y

RUN useradd -s /bin/bash -m -d ${APPDIR} couchbase && \
    chmod 700 ${APPDIR}

WORKDIR /tmp

RUN mkdir -p /opt/couchbase/${VERSION} && \
    wget https://packages.couchbase.com/releases/${VERSION}/couchbase-server-community_${VERSION}-ubuntu18.04_amd64.deb -O couchbase.deb && \
    dpkg-deb -x couchbase.deb /opt/couchbase/${VERSION} && \
    rm -f couchbase.deb

RUN cd /opt/couchbase/${VERSION} && \
    rm -rf etc usr lib && \
    mv ./opt/couchbase/* . && \
    rmdir ./opt/couchbase && \
    rmdir ./opt

USER couchbase

WORKDIR ${APPDIR}
COPY --chown=couchbase ./entrypoint.sh .

CMD ["/bin/bash", "./entrypoint.sh"]