#!/bin/bash
#gameport=${gameport:-'27960'}
#rconport=${rconport:-'28960'}

gameport=`expr $1 + 27960`
rconport=`expr $1 + 28960`
servernum=`expr $1 + 1`

if [ "$admin" != "" ]; then
  echo "$admin|admin" > ~/.quakelive/27960/access.txt
fi
#
#stdbuf -oL -eL /home/${USER}/steam/steamapps/common/qlds/run_server_x64.sh \
#    +set net_strict 1 \
#    +set net_port $gameport \
#    +set sv_hostname "$name" \
#    +set fs_homepath /home/${USER}/.quakelive/27960 \
#    +set zmq_rcon_enable 1 \
#    +set zmq_rcon_password "quake1337!" \
#    +set zmq_rcon_port $rconport \
#    +set zmq_stats_enable 1 \
#    +set zmq_stats_password "stats" \
#    +set zmq_stats_port $gameport \
#    +set sv_tags "$tags"

exec /home/${USER}/steam/steamapps/common/qlds/run_server_x64_minqlx.sh \
+set net_strict 1 \
+set net_port $gameport \
+set sv_hostname "MindK Quake Server #$servernum" \
+set fs_homepath /home/user/.quakelive/$gameport \
+set zmq_rcon_enable 1 \
+set zmq_rcon_password "mindkickers" \
+set zmq_rcon_port $rconport \
+set zmq_stats_enable 1 \
+set zmq_stats_password "mindkickers" \
+set zmq_stats_port $gameport

