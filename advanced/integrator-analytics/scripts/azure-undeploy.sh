#!/usr/bin/env bash

# ------------------------------------------------------------------------
# Copyright 2019 WSO2, Inc. (http://wso2.com)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License
# ------------------------------------------------------------------------

set -e

ECHO=`which echo`
KUBECTL=`which kubectl`

# methods
function echoBold () {
    echo $'\e[1m'"${1}"$'\e[0m'
}


# WSO2 Enterprise Integrator
echoBold 'Deleting WSO2 Enterprise Integrator deployment...'
${KUBECTL} delete -f ../integrator/integrator-service.yaml
${KUBECTL} delete -f ../integrator/integrator-gateway-service.yaml
${KUBECTL} delete -f ../analytics/integrator-analytics-service.yaml
${KUBECTL} delete -f ../integrator/integrator-deployment.yaml
${KUBECTL} delete -f ../analytics/integrator-analytics-deployment.yaml
sleep 2m

# MySQL
echoBold 'Deleting the MySQL deployment...'
${KUBECTL} delete -f ../extras/rdbms/mysql/mysql-service.yaml
${KUBECTL} delete -f ../extras/rdbms/mysql/mysql-deployment.yaml
# ${KUBECTL} delete -f ../extras/rdbms/volumes/persistent-volumes.yaml
sleep 50s

# persistent storage
echoBold 'Deleting persistent volume and volume claim...'
${KUBECTL} delete -f ../integrator/integrator-volume-claims-azure.yaml
# ${KUBECTL} delete -f ../volumes/persistent-volumes.yaml

# delete the created Kubernetes Namespace
${KUBECTL} delete namespace wso2

echoBold 'Deleting Azure storage classes'
${KUBECTL} delete -f ../../../azure/rbac.yaml
${KUBECTL} delete -f ../../../azure/storage-class.yaml
${KUBECTL} delete -f ../../../azure/mysql-storage-class.yaml

# switch the context to default namespace
${KUBECTL} config set-context $(kubectl config current-context) --namespace=default

echoBold 'Finished'
