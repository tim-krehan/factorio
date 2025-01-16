#!/bin/sh

factoriosave="$SAVES_DIRECTORY/$WORLD_NAME.zip"

echo "save directory is '$factoriosave'"
cd $BIN_DIRECTORY

if [ ! -f "$factoriosave" ]; then
  echo "generating world"
  ./factorio/bin/x64/factorio \
    -map-gen-settings '$SETTINGS_DIRECTORY/map-gen-setting.json' \
    --create "$factoriosave" \
    --verbose

  echo "setting ownership to $USER:$GROUP"
  chown $USER:$GROUP "$factoriosave"
fi

./factorio/bin/x64/factorio \
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
