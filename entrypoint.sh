#!/bin/sh

factoriosave="$SAVES_DIRECTORY/$WORLD_NAME.zip"

echo "save directory is '$factoriosave'"

if [ ! -f "$factoriosave" ]; then
  echo "generating world"
  . $BIN_DIRECTORY/factorio/bin/x64/factorio \
    -map-gen-settings '$SETTINGS_DIRECTORY/map-gen-setting.json' \
    --create "$factoriosave"

  chown $USER:$GROUP "$factoriosave"
fi

. $BIN_DIRECTORY/factorio/bin/x64/factorio \
  --start-server \
  $SAVES_DIRECTORY/$WORLD_NAME.zip \
  --server-settings \
  $SETTINGS_DIRECTORY/server-settings.json \
  --use-server-whitelist \
  $SETTINGS_DIRECTORY/server-whitelist.json \
  --server-adminlist \
  $SETTINGS_DIRECTORY/server-adminlist.json \
  --console-log \
  $LOG_DIRECTORY/$WORLD_NAME.log \
  --verbose
