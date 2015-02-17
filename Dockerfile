FROM ubuntu:14.04
MAINTAINER CDRC
# --TAG: spacelis/ckan-docker-solr

# Install Java
RUN apt-get -q -y update
RUN DEBIAN_FRONTEND=noninteractive apt-get -q -y install default-jre-headless

# Install Solr
ENV SOLR_HOME /opt/solr/example/solr
ENV SOLR_VERSION 4.10.3
ENV SOLR solr-$SOLR_VERSION
RUN mkdir -p /opt/solr
ADD https://archive.apache.org/dist/lucene/solr/$SOLR_VERSION/$SOLR.tgz /opt/$SOLR.tgz
RUN tar zxf /opt/$SOLR.tgz -C /opt/solr --strip-components 1

# Install CKAN Solr core
RUN mv $SOLR_HOME/collection1/ $SOLR_HOME/ckan/
RUN echo name=ckan > $SOLR_HOME/ckan/core.properties
RUN mkdir -p /etc/solr_ckan
RUN mv $SOLR_HOME/ckan/conf/schema.xml /etc/solr_ckan/
RUN ln -s /etc/solr_ckan/schema.xml $SOLR_HOME/ckan/conf/schema.xml

EXPOSE 8983
WORKDIR /opt/solr/example
VOLUME ["/etc/solr_ckan"]
CMD ["java", "-jar", "start.jar"]
