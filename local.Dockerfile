FROM  alpine:3.9.5 AS build

ARG DATART_ZIP

ADD $DATART_ZIP /

RUN mkdir -p /opt/datart && unzip $DATART_ZIP -d /opt/datart \
&& rm -rf $DATART_ZIP 
#&& cp -v /opt/datart/config/profiles/application-config.yml /opt/datart/config/profiles/application-config.yml

ADD bin/docker-entrypoint.sh /opt/datart/bin/docker-entrypoint.sh

RUN chmod +x /opt/datart/bin/docker-entrypoint.sh

FROM  openjdk:8u242-jdk AS base

LABEL MAINTAINER="tbcheng89@gamil.com"

COPY --from=build /opt /opt
#把datart相关的包单独放置在镜像层，便于再次构建推送时，仅推送变更docker layer
#COPY --from=build /opt/datart/bin/* /opt/datart/bin/
#COPY --from=build /opt/datart/config/* /opt/datart/config/
#COPY --from=build /opt/datart/lib/[^datart]* /opt/datart/lib/
#COPY --from=build /opt/datart/lib/datart* /opt/datart/lib_datart/
#COPY --from=build /opt/datart/static /opt/datart/static

ENV DATART3_HOME /opt/datart
ENV OPENSSL_CONF=/etc/ssl/

WORKDIR /opt/datart

CMD ["./bin/datart-server.sh","start"]

EXPOSE 8080