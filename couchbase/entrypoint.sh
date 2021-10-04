#!/bin/bash

if [[ "${NODE_TYPE}" == "init" ]]; then
  ${APPDIR}/${VERSION}/bin/couchbase-server --start
  sleep 5

  couchbase-cli cluster-init \
    --cluster $(hostname -i) --cluster-name SeemsCloud \
    --cluster-username ${USERNAME} --cluster-password ${PASSWORD} \
    --cluster-ramsize 4096 --cluster-index-ramsize 256 --cluster-fts-ramsize 256 \
    --cluster-eventing-ramsize 256 --cluster-analytics-ramsize 1024

  couchbase-cli setting-ldap \
    --cluster localhost --username admin --password admin1 \
    --authentication-enabled 1 --authorization-enabled 1 \
    --hosts ldap --port 389 --encryption none \
    --bind-dn "uid=auth,ou=users,dc=seems,dc=cloud" --bind-password "auth" \
    --user-dn-query "ou=users,dc=seems,dc=cloud??one?(uid=%u)" \
    --group-query "ou=groups,dc=seems,dc=cloud??one?(&(objectclass=groupOfUniqueNames)(uniquemember=uid=%u,ou=users,dc=seems,dc=cloud))"

  couchbase-cli user-manage \
    --cluster localhost --username admin --password admin1 \
    --set-group --group-name admins --roles admin \
    --ldap-ref "cn=couchbase_ui,ou=groups,dc=seems,dc=cloud"

  ${APPDIR}/${VERSION}/bin/couchbase-server --stop
  sleep 5
elif [[ ${NODE_TYPE} == "join" ]]; then
  ${APPDIR}/${VERSION}/bin/couchbase-server --start
  sleep 5

  curl http://${NODE_JOIN}:8091/controller/addNode \
    -v -X POST \
    -u "${USERNAME}:${PASSWORD}" \
    -d "hostname=http://$(hostname -i)" \
    -d "user=${USERNAME}" \
    -d "password=${PASSWORD}" \
    -d 'services=kv,n1ql,index'

  ${APPDIR}/${VERSION}/bin/couchbase-server --stop
  sleep 5
fi

${APPDIR}/${VERSION}/bin/couchbase-server -- -kernel global_enable_tracing false -noinput
