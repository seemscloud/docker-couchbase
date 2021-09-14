#!/bin/bash

if [[ "${NODE_TYPE}" == "init" ]]; then
  ${APPDIR}/${VERSION}/bin/couchbase-server --start
  sleep 5

  couchbase-cli cluster-init \
    --cluster $(hostname -i) --cluster-name SeemsCloud \
    --cluster-username ${USERNAME} --cluster-password ${PASSWORD} \
    --cluster-ramsize 4096 --cluster-index-ramsize 256 --cluster-fts-ramsize 256 \
    --cluster-eventing-ramsize 256 --cluster-analytics-ramsize 1024

  ${APPDIR}/${VERSION}/bin/couchbase-server --stop
  sleep 5
elif [[ ${NODE_TYPE} == "join" ]]; then
  ${APPDIR}/${VERSION}/bin/couchbase-server --start
  sleep 5

  curl http://couchbase-init:8091/controller/addNode \
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
