FROM  alpine:3.9.5 AS build

ARG DATART_ZIP

ADD $DATART_ZIP /

RUN mkdir -p /opt/datart && unzip $DATART_ZIP -d /opt/datart \
&& rm -rf $DATART_ZIP \
&& cp -v /opt/datart/config/application-config.yml.example /opt/datart/config/application-config.yml

ADD bin/docker-entrypoint.sh /opt/datart/bin/docker-entrypoint.sh

RUN chmod +x /opt/datart/bin/docker-entrypoint.sh

FROM  openjdk:8u242-jdk AS base

LABEL MAINTAINER="tbcheng89@gamil.com"

COPY --from=build /opt /opt

ENV DATART3_HOME /opt/datart
ENV OPENSSL_CONF=/etc/ssl/

WORKDIR /opt/datart

CMD ["./bin/datart-server.sh"]

EXPOSE 8080