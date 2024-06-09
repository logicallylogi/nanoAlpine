FROM alpine:latest

RUN apk --no-cache update
RUN apk --no-cache --purge del libc-dev libc-utils scanelf pax-utils
RUN apk --no-cache --no-scripts --purge del alpine-baselayout alpine-baselayout-data
RUN rm -rf /root
RUN rm -rf /etc/logrotate.d /etc/os-release /etc/alpine-release /etc/busybox-paths.d /etc/secfixes.d /etc/udhcpc /etc/udhcpd.conf /etc/issue
RUN rm -rf /var/cache/* /var/lib/*

RUN apk --no-cache upgrade
