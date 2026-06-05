ARG BUILD_FROM=seakee/cpa-manager-plus:v1.0.1
FROM alpine:3.21.3
ARG BUILD_FROM=seakee/cpa-manager-plus:v1.0.1

RUN apk add --no-cache ca-certificates jq wget

RUN set -eu; \
  version="${BUILD_FROM##*:}"; \
  mkdir -p /www; \
  wget -O /www/management.html "https://github.com/seakee/CPA-Manager-Plus/releases/download/${version}/management.html"

COPY rootfs /
COPY run.sh /run.sh

RUN chmod 755 /run.sh /etc/cont-init.d/20-folders.sh /etc/cont-init.d/99-run.sh

ENTRYPOINT ["/run.sh"]
