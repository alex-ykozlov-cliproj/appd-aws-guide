FROM appdynamics/machine-agent-analytics:latest

ENV MACHINE_AGENT_HOME /opt/appdynamics
ENV MACHINE_EXT_LIST="AWSLambdaMonitor;AWSELBMonitor;AWSAPIGatewayMonitor;AWSRDSMonitor;AWSS3Monitor;AWSCustomNamespaceMonitor"

COPY startup.sh ${MACHINE_AGENT_HOME}
RUN chmod +x ${MACHINE_AGENT_HOME}/startup.sh
# Copy log4j.xml
COPY log4j.xml ${MACHINE_AGENT_HOME}/conf/logging/log4j.xml

# Copy extensions
COPY appd-ext/AWSLambdaMonitor ${MACHINE_AGENT_HOME}/monitors/AWSLambdaMonitor
COPY appd-ext/AWSELBMonitor ${MACHINE_AGENT_HOME}/monitors/AWSELBMonitor
COPY appd-ext/AWSAPIGatewayMonitor ${MACHINE_AGENT_HOME}/monitors/AWSAPIGatewayMonitor
COPY appd-ext/AWSRDSMonitor ${MACHINE_AGENT_HOME}/monitors/AWSRDSMonitor
COPY appd-ext/AWSS3Monitor ${MACHINE_AGENT_HOME}/monitors/AWSS3Monitor
COPY appd-ext/AWSCustomNamespaceMonitor ${MACHINE_AGENT_HOME}/monitors/AWSCustomNamespaceMonitor

# If building locally you can copy rather than pulling from GitHub:

CMD "${MACHINE_AGENT_HOME}/startup.sh"

