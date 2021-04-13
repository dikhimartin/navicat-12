FROM alpine:latest as extractor

COPY navicat.tar.xz /opt/
RUN apk add lrzip && \
	cd /opt && \
	mkdir navicat && \
	tar -xJvf navicat.tar.xz --strip-components=1 -C navicat && \
	rm navicat.tar.xz

FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive \
	DISPLAY=:0

RUN sed -i 's/archive.ubuntu.com/kartolo.sby.datautama.net.id/g' /etc/apt/sources.list && \
	sed -i 's/security.ubuntu.com/kartolo.sby.datautama.net.id/g' /etc/apt/sources.list && \
	apt-get update 1>/dev/null && \
    apt-get install -y --no-install-recommends wine-stable 1>/dev/null && \
    useradd -u 1000 -m wine && \
    apt-get clean && \
    find /var/cache/apt/archives -type f -delete && \
    find /var/lib/apt/lists -type f -delete
COPY --chown=1000:1000 --from=extractor /opt/navicat /home/wine/navicat
USER 1000:1000
WORKDIR /home/wine
RUN mkdir -p Desktop Documents

CMD [ "sh", "-c", "/home/wine/navicat/navicat" ]
