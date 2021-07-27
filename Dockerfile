FROM ich777/debian-baseimage

LABEL maintainer="admin@minenet.at"

RUN apt-get update && \
	apt-get -y install --no-install-recommends curl xz-utils && \
	rm -rf /var/lib/apt/lists/*

ENV DATA_DIR="/serverdata"
ENV SERVER_DIR="${DATA_DIR}/serverfiles"
ENV GAME_CONFIG="autoexec.cfg"
ENV GAME_PORT=8303
ENV UMASK=000
ENV UID=99
ENV GID=100
ENV DATA_PERM=770
ENV USER="ddnet"

RUN mkdir $DATA_DIR && \
	mkdir $SERVER_DIR && \
	useradd -d $SERVER_DIR -s /bin/bash $USER && \
	chown -R $USER $DATA_DIR && \
	ulimit -n 2048

ADD /scripts/ /opt/scripts/
RUN chmod -R 770 /opt/scripts/

#Server Start
ENTRYPOINT ["/opt/scripts/start.sh"]