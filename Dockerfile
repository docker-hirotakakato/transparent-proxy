FROM alpine:latest

EXPOSE 3128
CMD ["sh", "-c", "chown squid: /dev/stderr /dev/stdout && exec squid -N"]

RUN set -eux; \
    apk add --no-cache squid; \
    sed /etc/squid/squid.conf \
      -e '/^#http_access deny to_localhost$/ s/^#//' \
      -e '/^#cache_dir / s/^#//' \
      -e '/^cache_dir / s/ 100 / 16384 /' \
      -e '/^cache_dir / a maximum_object_size 8 GB' \
      -e '$ a \\n' \
      -e '$ a access_log stdio:/dev/stdout combined' \
      -e '$ a cache_log /dev/stderr' \
      -e '$ a forwarded_for delete' \
      -e '$ a shutdown_lifetime 1 second' \
      -e '$ a visible_hostname localhost' \
      -i; \
    chown squid: /dev/stderr; \
    squid -Nz

VOLUME ["/var/cache/squid"]
