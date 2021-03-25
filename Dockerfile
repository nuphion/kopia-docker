FROM golang:alpine as build
RUN apk update --no-cache && apk add --no-cache ca-certificates curl git make
RUN git clone https://github.com/kopia/kopia.git
RUN make -C kopia install-noui

FROM alpine:latest
ARG PLATFORM_ARCH="amd64"

ENV KOPIA_CONFIG_PATH=/config/kopia-config/repository.config
ENV KOPIA_LOG_DIR=/config/kopia-config/logs
ENV KOPIA_CACHE_DIRECTORY=/config/kopia-config/cache
ENV KOPIA_CHECK_FOR_UPDATES=false
ENV RCLONE_CONFIG=/config/rclone.conf

RUN apk update --no-cache && apk add --no-cache ca-certificates nano curl

ADD https://github.com/just-containers/s6-overlay/releases/download/v2.2.0.1/s6-overlay-amd64-installer /tmp/
RUN chmod +x /tmp/s6-overlay-amd64-installer && \
    /tmp/s6-overlay-amd64-installer / && \
    rm /tmp/s6-overlay-amd64-installer

COPY --from=build /go/bin/kopia /usr/bin/kopia

RUN curl -o /tmp/rclone.zip -L \
    "https://downloads.rclone.org/rclone-current-linux-${PLATFORM_ARCH}.zip" && \
    unzip /tmp/rclone.zip -d /tmp && \
    mv /tmp/rclone-*-linux-${PLATFORM_ARCH}/rclone /usr/bin

RUN mkdir -p /config /data

COPY root/ /

VOLUME ["/config"]

ENTRYPOINT ["/init"]