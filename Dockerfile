FROM docker.io/library/ubuntu:24.04

ARG VERSION=2.0.28
ARG WORLD_NAME=factorio

ARG USER=factorio
ARG USERID=1337
ARG GROUP=factorio

ARG SAVES_DIRECTORY=/var/factorio/saves
ARG LOG_DIRECTORY=/var/log/factorio
ARG SETTINGS_DIRECTORY=/etc/factorio
ARG BIN_DIRECTORY=/opt/factorio

ENV BIN_DIRECTORY $BIN_DIRECTORY
ENV SAVES_DIRECTORY $SAVES_DIRECTORY
ENV SETTINGS_DIRECTORY $SETTINGS_DIRECTORY
ENV LOG_DIRECTORY $LOG_DIRECTORY
ENV USER $USER
ENV GROUP $GROUP
ENV WORLD_NAME $WORLD_NAME

LABEL appversion=$VERSION

COPY entrypoint.sh "/entrypoint.sh"

COPY map-gen-setting.json $SETTINGS_DIRECTORY/map-gen-setting.json

COPY server-settings.json $SETTINGS_DIRECTORY/server-settings.json
COPY server-whitelist.json $SETTINGS_DIRECTORY/server-whitelist.json
COPY server-adminlist.json $SETTINGS_DIRECTORY/server-adminlist.json

COPY mod-list.json $BIN_DIRECTORY/mod-list.json

VOLUME $SAVES_DIRECTORY

# create user & group
RUN groupadd $GROUP && \
  useradd --no-create-home --shell /bin/sh --uid $USERID --gid $GROUP $USER && \
  # install nessecary dependencies
  apt update && apt upgrade -y && \
  apt install curl xz-utils -y && \
  # create folder
  mkdir -p $SAVES_DIRECTORY && \
  mkdir -p $LOG_DIRECTORY && \
  mkdir -p $SETTINGS_DIRECTORY && \
  mkdir -p $BIN_DIRECTORY && \
  # download binary
  curl "https://www.factorio.com/get-download/$VERSION/headless/linux64" -SsLo "/tmp/factorio_archive.tar.gz" && \
  # extract it to binary dir
  tar -C "$BIN_DIRECTORY" -xf "/tmp/factorio_archive.tar.gz" && \
  # make entrypoint executable & set it's permissions
  chmod +x "/entrypoint.sh" && \
  chown "$USER:$GROUP" "/entrypoint.sh" && \
  # set folder permissions
  chown $USER:$GROUP -R $SAVES_DIRECTORY $LOG_DIRECTORY $SETTINGS_DIRECTORY $BIN_DIRECTORY && \
  #set binary permissions
  chmod +x "$BIN_DIRECTORY/factorio/bin/x64/factorio" && \
  # remove downloaded zipfile
  rm "/tmp/factorio_archive.tar.gz"

EXPOSE 34197/udp
EXPOSE 27015/tcp

USER $USER
ENTRYPOINT ["/entrypoint.sh"]