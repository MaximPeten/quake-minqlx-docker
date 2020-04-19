#!/bin/bash

set -e

gameport=`expr $1 + 27960`
rconport=`expr $1 + 28960`
servernum=`expr $1 + 1`

export SERVER_HOSTNAME="${SERVER_HOSTNAME:-MindK Quake Server}"
export SERVER_PASSWORD="${SERVER_PASSWORD:-}"
export RCON_PASSWORD="${RCON_PASSWORD:-}"
export STATS_PASSWORD="${STATS_PASSWORD:-}"
export STEAM_ID="${STEAM_ID:-}"

# Install Quake Live Server
#"$STEAM_DIR/steamcmd.sh" +login anonymous +force_install_dir "$QLDS_DIR" +app_update "$QUAKE_APP_ID" +quit

if [ "$STEAM_ID" != "" ]; then
  echo "$STEAM_ID|admin" > ~/.quakelive/27960/access.txt
fi

exec "$BASH" "$QLDS_DIR/run_server_x64_minqlx.sh" \
+set net_strict 1 \
+set net_port $gameport \
+set sv_hostname "$SERVER_HOSTNAME #$servernum" \
+set fs_homepath /home/user/.quakelive/$gameport \
+set zmq_rcon_enable 1 \
+set zmq_rcon_password "$RCON_PASSWORD" \
+set zmq_rcon_port $rconport \
+set zmq_stats_enable 1 \
+set zmq_stats_password "$STATS_PASSWORD" \
+set zmq_stats_port $gameport
