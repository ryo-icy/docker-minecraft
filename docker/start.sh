#!/bin/bash
cd /minecraft
if [ -e eula.txt ]; then
    sed -i '/eula=/d' eula.txt
fi
echo "eula=true" >> eula.txt
rcon_port=$(yq -r ".port" ~/.rcon-cli.yaml)
rcon_pass=$(yq -r ".password" ~/.rcon-cli.yaml)
sed -i '/enable-rcon=/d' server.properties
echo "enable-rcon=true" >> server.properties
sed -i '/rcon.password=/d' server.properties
echo "rcon.password="$rcon_pass >> server.properties
sed -i '/rcon.port=/d' server.properties
echo "rcon.port="$rcon_port >> server.properties

exec minecraft-runner "java -Xms${MIN_MEM} -Xmx${MAX_MEM} -Dlog4j2.formatMsgNoLookups=true -jar ${JAR_FILE}"