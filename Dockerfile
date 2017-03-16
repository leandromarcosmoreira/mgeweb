# Use latest mgeweb/wildfly image as the base
FROM mgeweb/wildfly

# Set the WILDFLY_VERSION env variable
ENV WILDFLY_VERSION 10.0.0.Final
ENV JBOSS_HOME /opt/jboss/wildfly

USER root

# Add the WildFly distribution to /opt, and make wildfly the owner of the extracted tar content
# Make sure the distribution is available from a well-known place
RUN cd $HOME \
    && curl -O https://downloads-jiva-pkgmgr.s3.amazonaws.com/pkgmgr_jiva_unix_x64_2_2b35.tar.gz \
    && tar xf pkgmgr_jiva_unix_x64_2_2b35.tar.gz \
    && mv jivaW_gerenciador_de_pacotes /opt/. \
    && rm pkgmgr_jiva_unix_x64_2_2b35.tar.gz \
    && curl -O http://downloads-jiva-pkgs.s3-sa-east-1.amazonaws.com/jiva-w_3.16.14b23.pkg \
    && mv jiva-w_3.16.14b23.pkg /opt/jivaW_gerenciador_de_pacotes/pkgs \
    && curl -O http://central-ajuda-jiva.s3.amazonaws.com/jvwajuda-3.16.0.pkg \
    && mv jvwajuda-3.16.0.pkg /opt/jivaW_gerenciador_de_pacotes/pkgs \
    && curl -O https://downloads-jiva-wpm.s3.amazonaws.com/jiva-w_atualizador-web-2.4b27.pkg \
    && mv jiva-w_atualizador-web-2.4b27.pkg /opt/jivaW_gerenciador_de_pacotes/pkgs

# Ensure signals are forwarded to the JVM process correctly for graceful shutdown
ENV LAUNCH_JBOSS_IN_BACKGROUND true

USER jboss

# Expose the ports we're interested in
EXPOSE 8080

# Set the default command to run on boot
# This will boot WildFly in the standalone mode and bind to all interface
CMD ["/opt/jboss/wildfly/bin/standalone.sh", "-b", "0.0.0.0"]