ARG BUILD_FROM
FROM ${BUILD_FROM}

COPY rootfs /
COPY run.sh /run.sh

RUN chmod 755 /run.sh /etc/cont-init.d/20-folders.sh

ENTRYPOINT ["/run.sh"]
