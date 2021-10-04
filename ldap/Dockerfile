FROM ubuntu:focal

ARG PASSWORD
ARG DOMAIN

ENV DEBIAN_FRONTEND=noninteractive

SHELL ["/bin/bash", "-c"]

RUN apt-get update && \
    apt-get install slapd ldap-utils -y

RUN slapd && \
    echo slapd slapd/internal/adminpw password "${PASSWORD}" | \
    debconf-set-selections; echo slapd slapd/internal/generated_adminpw password "${PASSWORD}" | \
    debconf-set-selections; echo slapd slapd/password1 password "${PASSWORD}" | \
    debconf-set-selections; echo slapd slapd/password2 password "${PASSWORD}" | \
    debconf-set-selections; echo slapd slapd/domain string "${DOMAIN}" | \
    debconf-set-selections; echo slapd shared/organization string "${DOMAIN}" | \
    debconf-set-selections; dpkg-reconfigure -f noninteractive slapd && \
    slapcat

COPY ./files/settings.ldif .

RUN slapd && \
    echo "cn=admin,dc=${ORGANIZATION},dc=${DOMAIN}" && \
    ldapadd -x -D "cn=admin,dc=seems,dc=cloud" -f settings.ldif -w ${PASSWORD}

CMD ["slapd", "-d", "0"]