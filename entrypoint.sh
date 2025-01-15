factoriosave="{{SAVES_DIRECTORY}}/{{WORLD_NAME}}.zip"

if [ ! -f "$factoriosave" ]; then
  echo "generating world"
  exec {{BIN_DIRECTORY}}/bin/x64/factorio \
    -map-gen-settings '{{SETTINGS_DIRECTORY}}/map-gen-setting.json' \
    --create "$factoriosave"

  chmod {{USER}}:{{GROUP}} "$factoriosave"
fi

exec {{BIN_DIRECTORY}}/bin/x64/factorio "$@"
