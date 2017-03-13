# Use latest jboss/base-jdk:8 image as the base
FROM jboss/base-jdk:8

MAINTAINER Leandro Moreira <leandromarcosmoreira@gmail.com>

# Set the WILDFLY_VERSION env variable
ENV WILDFLY_VERSION 10.0.0.Final
#ENV WILDFLY_SHA1 9ee3c0255e2e6007d502223916cefad2a1a5e333
ENV JBOSS_HOME /opt/mgeweb/wildfly

LABEL io.k8s.description="Platform for building and running JEE applications on WildFly 10.0.0.Final" \
      io.k8s.display-name="WildFly 10.0.0.Final" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,wildfly,wildfly10"

USER root

# Add the WildFly distribution to /opt, and make wildfly the owner of the extracted tar content
# Make sure the distribution is available from a well-known place
RUN cd $HOME \
    && (curl -v https://downloads-sankhya-tools.s3-sa-east-1.amazonaws.com/Wildfly_10.0.0_Sankhya_mod_5.zip | tar -zx --strip-components=1 -C /wildfly) \
    && unzip Wildfly_10.0.0_Sankhya_mod_5.zip \
    && mv $HOME/wildfly_producao $JBOSS_HOME \
    && rm Wildfly_10.0.0_Sankhya_mod_5.zip \
    && chown -R jboss:0 ${JBOSS_HOME} \
    && chmod -R g+rw ${JBOSS_HOME}

# Ensure signals are forwarded to the JVM process correctly for graceful shutdown
ENV LAUNCH_JBOSS_IN_BACKGROUND true

USER jboss

# Expose the ports we're interested in
EXPOSE 8080

# Set the default command to run on boot
# This will boot WildFly in the standalone mode and bind to all interface
#CMD ["/opt/mgeweb/wildfly/bin/standalone.sh", "-b", "0.0.0.0"]
