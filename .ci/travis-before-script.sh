#!/bin/bash

set -e -x

if [[ "${TOXENV}" == *-rdb ]]; then
    rethinkdb --daemon
elif [[ "${BIGCHAINDB_DATABASE_BACKEND}" == mongodb ]]; then
    wget http://downloads.mongodb.org/linux/mongodb-linux-x86_64-3.4.4.tgz -O /tmp/mongodb.tgz
    tar -xvf /tmp/mongodb.tgz
    mkdir /tmp/mongodb-data
    ${PWD}/mongodb-linux-x86_64-3.4.4/bin/mongod --dbpath=/tmp/mongodb-data --replSet=bigchain-rs &> /dev/null &
elif [[ "${BIGCHAINDB_DATABASE_BACKEND}" == mongodb-ssl ]]; then
    wget https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-ubuntu1404-3.4.4.tgz -O /tmp/mongodb-ssl.tgz
    tar -xvf /tmp/mongodb-ssl.tgz
    mkdir /tmp/mongodb-ssl-data
    echo "marker1"
    sudo netstat -nalp 
    sudo ps -ef
    ${PWD}/mongodb-linux-x86_64-3.4.4/bin/mongod \
        --dbpath=/tmp/mongodb-ssl-data \
        --replSet=bigchain-rs \
        --sslAllowInvalidHostnames \
        --sslMode=requireSSL \
        --sslCAFile=$TRAVIS_BUILD_DIR/tests/backend/mongodb-ssl/certs/ca.crt \
        --sslCRLFile=$TRAVIS_BUILD_DIR/tests/backend/mongodb-ssl/certs/crl.pem \
        --sslPEMKeyFile=$TRAVIS_BUILD_DIR/tests/backend/mongodb-ssl/certs/test_mdb_ssl_cert_and_key.pem &> /dev/null &
    echo "marker2"
    sudo netstat -nalp
    sudo netstat -nalp
    sudo ps -ef
fi
