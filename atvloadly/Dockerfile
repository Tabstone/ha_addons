ARG BUILD_FROM
FROM ${BUILD_FROM}

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends jq \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY rootfs /
COPY run.sh /run.sh

RUN chmod 755 /run.sh /etc/cont-init.d/20-folders.sh /etc/cont-init.d/99-run.sh

ENTRYPOINT ["/run.sh"]
