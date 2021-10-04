FROM ubuntu:bionic

ARG VERSION
ENV VERSION="${VERSION}"

ARG APPDIR="/opt/couchbase"
ENV APPDIR="${APPDIR}"

ENV PATH="${APPDIR}/${VERSION}/bin:${PATH}"

ENV DEBIAN_FRONTEND=noninteractive

SHELL ["/bin/bash", "-c"]

RUN apt-get update && \
    apt-get install wget file xz-utils -y

RUN useradd -s /bin/bash -m -d ${APPDIR} couchbase && \
    chmod 700 ${APPDIR}

WORKDIR /tmp

RUN mkdir -p /opt/couchbase/${VERSION} && \
    wget https://packages.couchbase.com/releases/${VERSION}/couchbase-server-enterprise_${VERSION}-ubuntu18.04_amd64.deb -O couchbase.deb && \
    dpkg-deb -x couchbase.deb ${APPDIR}/${VERSION} && \
    rm -f couchbase.deb

WORKDIR ${APPDIR}

RUN cd ${VERSION} && \
    rm -rf etc usr lib && \
    mv opt/couchbase/* . && \
    rm -rf opt && \
    chown -R couchbase:couchbase * && \
    ./bin/install/reloc.sh `pwd`

USER couchbase

COPY --chown=couchbase ./entrypoint.sh .

CMD ["/bin/bash", "./entrypoint.sh"]