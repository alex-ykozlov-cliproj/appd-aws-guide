#!/usr/bin/env bash
GREEN='\033[92m'
BLUE='\033[96m'
YELLOW='\033[93m'
GREY='\033[37m'
CLEAR='\033[90m'

# Sample Docker start script for the AppDynamics Standalone Machine Agent
# See the AppDynamics Product Docs (Standalone Machine Agent Configuration Reference)
# Environment variables are passed to the container at runtime

# $MACHINE_AGENT_HOME/updateAnalyticsAgent.sh $MACHINE_AGENT_HOME

# Default the unique host id to thousandeyes-<appname>
if [ "x${APPDYNAMICS_AGENT_UNIQUE_HOST_ID}" == "x" ]; then
  APPDYNAMICS_AGENT_UNIQUE_HOST_ID="aws-${APPDYNAMICS_AGENT_APPLICATION_NAME}"
fi

MA_PROPERTIES=${APPDYNAMICS_MA_PROPERTIES}
MA_PROPERTIES+=" -Dappdynamics.controller.hostName=${APPDYNAMICS_CONTROLLER_HOST_NAME}"
MA_PROPERTIES+=" -Dappdynamics.controller.port=${APPDYNAMICS_CONTROLLER_PORT}"
MA_PROPERTIES+=" -Dappdynamics.agent.accountName=${APPDYNAMICS_AGENT_ACCOUNT_NAME}"
MA_PROPERTIES+=" -Dappdynamics.agent.accountAccessKey=${APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY}"
MA_PROPERTIES+=" -Dappdynamics.controller.ssl.enabled=${APPDYNAMICS_CONTROLLER_SSL_ENABLED}"
MA_PROPERTIES+=" -Dappdynamics.sim.enabled=${APPDYNAMICS_SIM_ENABLED}"


if [ "x${APPDYNAMICS_DOCKER_ENABLED}" != "x" ]; then
  MA_PROPERTIES+=" -Dappdynamics.docker.enabled=${APPDYNAMICS_DOCKER_ENABLED}"
fi

MA_PROPERTIES+=" -Dappdynamics.docker.container.containerIdAsHostId.enabled=true"


if [ "x${APPDYNAMICS_MACHINE_HIERARCHY_PATH}" != "x" ]; then
    MA_PROPERTIES+=" -Dappdynamics.machine.agent.hierarchyPath=SVM-${APPDYNAMICS_MACHINE_HIERARCHY_PATH}"
fi

if [ "x${APPDYNAMICS_AGENT_UNIQUE_HOST_ID}" != "x" ]; then
    MA_PROPERTIES+=" -Dappdynamics.agent.uniqueHostId=${APPDYNAMICS_AGENT_UNIQUE_HOST_ID}"
fi

if [ "x${APPDYNAMICS_AGENT_PROXY_HOST}" != "x" ]; then
    MA_PROPERTIES+=" -Dappdynamics.http.proxyHost=${APPDYNAMICS_AGENT_PROXY_HOST}"
fi

if [ "x${APPDYNAMICS_AGENT_PROXY_PORT}" != "x" ]; then
    MA_PROPERTIES+=" -Dappdynamics.http.proxyPort=${APPDYNAMICS_AGENT_PROXY_PORT}"
fi

if [ "x${APPDYNAMICS_AGENT_PROXY_USER}" != "x" ]; then
    MA_PROPERTIES+=" -Dappdynamics.http.proxyUser=${APPDYNAMICS_AGENT_PROXY_USER}"
fi

if [ "x${APPDYNAMICS_AGENT_PROXY_PASS}" != "x" ]; then
    MA_PROPERTIES+=" -Dappdynamics.http.proxyPasswordFile=${APPDYNAMICS_AGENT_PROXY_PASS}"
fi

if [ "x${APPDYNAMICS_AGENT_APPLICATION_NAME}" != "x" ]; then
  MA_PROPERTIES+=" -Dappdynamics.agent.applicationName=${APPDYNAMICS_AGENT_APPLICATION_NAME}"
fi

if [ "x${APPDYNAMICS_AGENT_TIER_NAME}" != "x" ]; then
  MA_PROPERTIES+=" -Dappdynamics.agent.tierName=${APPDYNAMICS_AGENT_TIER_NAME}"
fi

if [ "x${APPDYNAMICS_AGENT_NODE_NAME}" != "x" ]; then
  MA_PROPERTIES+=" -Dappdynamics.agent.nodeName=${APPDYNAMICS_AGENT_NODE_NAME}"
fi

if [ "x${APPDYNAMICS_AGENT_METRIC_LIMIT}" != "x" ]; then
  MA_PROPERTIES+=" -Dappdynamics.agent.maxMetrics=${APPDYNAMICS_AGENT_METRIC_LIMIT}"
fi

# Taking the approach of using system properties to set logging levels.
SINGULARITY_LOG_LEVEL="info"
if [ "x${SINGULARITY_LOGGING_LEVEL}" != "x" ]; then
  SINGULARITY_LOG_LEVEL="${SINGULARITY_LOGGING_LEVEL}"
fi

APPD_LOG_LEVEL="info"
if [ "x${APPDYNAMICS_LOGGING_LEVEL}" != "x" ]; then
  APPD_LOG_LEVEL="${APPDYNAMICS_LOGGING_LEVEL}"
fi

SIGAR_LOG_LEVEL="info"
if [ "x${SIGAR_LOGGING_LEVEL}" != "x" ]; then
  SIGAR_LOG_LEVEL="${SIGAR_LOGGING_LEVEL}"
fi

MA_PROPERTIES+=" -Dsingularity.logging.level=${SINGULARITY_LOG_LEVEL} -Dappdynamics.logging.level=${APPD_LOG_LEVEL} -Dsigar.logging.level=${SIGAR_LOG_LEVEL}"

echo "\nMA_PROPERTIES: ${MA_PROPERTIES}\n"

echo "\nMA EXTENSION LIST: ${MACHINE_EXT_LIST}"

list=$(echo ${MACHINE_EXT_LIST} | tr ";" "\n")
for ext in $list
do
  sed -i "s/awsAccessKey: x/awsAccessKey: ${AWS_ACCESS_KEY}/g"  ${MACHINE_AGENT_HOME}/monitors/$ext/config.yml
  sed -i "s/awsSecretKey: x/awsSecretKey: ${AWS_SECRET_KEY}/g"  ${MACHINE_AGENT_HOME}/monitors/$ext/config.yml
  sed -i "s/displayAccountName: x/displayAccountName: ${AWS_DISPLAY_ACCOUNT_NAME}/g"  ${MACHINE_AGENT_HOME}/monitors/$ext/config.yml
  sed -i "s/regions: x/regions: ${AWS_REGIONS}/g"  ${MACHINE_AGENT_HOME}/monitors/$ext/config.yml
done


printf "Starting the ${BLUE} AppD Monitor Extension${CLEAR}\n"
printf " - Application:           ${YELLOW}${APPDYNAMICS_AGENT_APPLICATION_NAME}${CLEAR}\n" 
printf " - AppD Controller:       ${YELLOW}${APPDYNAMICS_CONTROLLER_HOST_NAME}${CLEAR}\n" 
printf " - Machine Agent Host ID: ${YELLOW}${APPDYNAMICS_AGENT_UNIQUE_HOST_ID}${CLEAR}\n" 


# Start Machine Agent
java ${MA_PROPERTIES} -jar ${MACHINE_AGENT_HOME}/machineagent.jar


