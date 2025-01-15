FROM docker.io/library/ubuntu:24.04

ARG USER=factorio
ARG GROUP=factorio
ARG VERSION=2.0.30

ARG SAVES_DIRECTORY=/var/factorio/saves
ARG LOG_DIRECTORY=/var/log/factorio
ARG SETTINGS_DIRECTORY=/etc/factorio
ARG BIN_DIRECTORY=/opt/factorio

ARG WORLD_NAME=factorio

LABEL appversion=$VERSION


RUN groupadd $GROUP && \
  useradd --no-create-home --shell /bin/sh --gid $GROUP $USER

RUN \
  apt update && apt upgrade -y && \
  apt install curl xz-utils -y && \
  curl "https://www.factorio.com/get-download/$VERSION/headless/linux64" -SsLo "/tmp/factorio_archive.tar.gz" && \
  mkdir -p $SAVES_DIRECTORY && \
  chown $USER:$GROUP -R $SAVES_DIRECTORY && \
  mkdir -p $LOG_DIRECTORY && \
  chown $USER:$GROUP -R $LOG_DIRECTORY && \
  mkdir -p $SETTINGS_DIRECTORY && \
  chown $USER:$GROUP -R $SETTINGS_DIRECTORY && \
  mkdir -p $BIN_DIRECTORY && \
  tar -C "$BIN_DIRECTORY" -xf "/tmp/factorio_archive.tar.gz" && \
  chown $USER:$GROUP -R "$BIN_DIRECTORY" && \
  chmod +x "$BIN_DIRECTORY/factorio/bin/x64/factorio" && \
  rm "/tmp/factorio_archive.tar.gz"

COPY entrypoint.sh "/entrypoint.sh"

RUN \
  sed "s={{BIN_DIRECTORY}}=$BIN_DIRECTORY=g" "/entrypoint.sh" && \
  sed "s={{SAVES_DIRECTORY}}=$SAVES_DIRECTORY=g" "/entrypoint.sh" && \
  sed "s={{SETTINGS_DIRECTORY}}=$SETTINGS_DIRECTORY=g" "/entrypoint.sh" && \
  sed "s={{LOG_DIRECTORY}}=$LOG_DIRECTORY=g" "/entrypoint.sh" && \
  sed "s={{USER}}=$USER=g" "/entrypoint.sh" && \
  sed "s={{GROUP}}=$GROUP=g" "/entrypoint.sh" && \
  sed "s={{WORLD_NAME}}/=$WORLD_NAME=g" "/entrypoint.sh" && \
  chmod +x "/entrypoint.sh" && \
  chown "$USER:$GROUP" "/entrypoint.sh"


COPY map-gen-setting.json $SETTINGS_DIRECTORY/map-gen-setting.json

COPY server-settings.json $SETTINGS_DIRECTORY/server-settings.json
COPY server-whitelist.json $SETTINGS_DIRECTORY/server-whitelist.json
COPY server-adminlist.json $SETTINGS_DIRECTORY/server-adminlist.json

COPY mod-list.json $BIN_DIRECTORY/mod-list.json

EXPOSE 34197/udp
EXPOSE 27015/tcp

VOLUME $SAVES_DIRECTORY

USER $USER
ENTRYPOINT ["/entrypoint.sh"]