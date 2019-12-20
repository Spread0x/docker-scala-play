FROM adoptopenjdk/openjdk13:latest
MAINTAINER Stanislav Sobolev <iamjacke@gmail.com>

ENV SBT_VERSION 1.3.5

# Install sbt
RUN apt-get update
RUN apt-get -y install bash unzip curl openssl ca-certificates 
# Checksum of sbt 
RUN curl -L -o /tmp/sbt-1.3.5.zip https://piccolo.link/sbt-${SBT_VERSION}.zip
RUN cd /tmp/; sha256sum sbt-1.3.5.zip > /tmp/sbt-downloaded.sha256
RUN curl -L -o /tmp/sbt.sha256 https://piccolo.link/sbt-${SBT_VERSION}.zip.sha256
RUN cmp /tmp/sbt-downloaded.sha256 /tmp/sbt.sha256
RUN mv /tmp/sbt-1.3.5.zip /tmp/sbt.zip

RUN mkdir -p /opt/sbt && \
  unzip /tmp/sbt.zip -d /opt/sbt && \
  rm /tmp/sbt.zip && \
  chmod +x /opt/sbt/sbt/bin/sbt && \
  ln -s /opt/sbt/sbt/bin/sbt /usr/bin/sbt && \
  rm -rf /tmp/* /var/cache/apk/*

# Prebuild with sbt
COPY . /tmp/build/

# sbt sometimes failed because of network. retry 3 times.
RUN cd /tmp/build && \
  (sbt compile || sbt compile || sbt compile) && \
  (sbt test:compile || sbt test:compile || sbt test:compile) && \
  rm -rf /tmp/build

CMD ["sbt"]
