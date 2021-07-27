#!/bin/bash
CUR_V="$(find ${SERVER_DIR} -maxdepth 1 -type f -name "installedv-*" | cut -d '-' -f 2)"
LAT_V="$(curl -s https://api.github.com/repos/ddnet/ddnet/tags | grep name | cut -d '"' -f4 | grep -v [a-z] | sort -V | tail -1)"

if [ -z "${LAT_V}" ]; then
  if [ -z "${CUR_V}" ]; then
    echo "---Can't get latest version from DDNet and no current installed version found!---"
    echo "---Putting server into sleep mode---"
    sleep infinity
  else
    LAT_V=${CUR_V}
  fi
fi

echo "---DDNet version check...---"
if [ -z "$CUR_V" ]; then
  echo "---DDNet not found, downloading!---"
  cd ${SERVER_DIR}
  wget -q -nc --show-progress --progress=bar:force:noscroll -O ${SERVER_DIR}/DDNet-${LAT_V}.tar.xz "https://ddnet.tw/downloads/DDNet-${LAT_V}-linux_x86_64.tar.xz"
  mkdir -p ${SERVER_DIR}/DDNet
  tar --directory ${SERVER_DIR}/DDNet --strip-components 1 -xf ${SERVER_DIR}/DDNet-${LAT_V}.tar.xz
  rm -rf ${SERVER_DIR}/DDNet-${LAT_V}.tar.xz ${SERVER_DIR}/DDNet/data/autoexec_server.cfg
  touch ${SERVER_DIR}/installedv-${LAT_V}
elif [ "$LAT_V" != "$CUR_V" ]; then
  echo "---Newer version found, installing!---"
  rm -rf ${SERVER_DIR}/installedv-* ${SERVER_DIR}/DDNet
  cd ${SERVER_DIR}
  wget -q -nc --show-progress --progress=bar:force:noscroll -O ${SERVER_DIR}/DDNet-${LAT_V}.tar.xz "https://ddnet.tw/downloads/DDNet-${LAT_V}-linux_x86_64.tar.xz"
  mkdir -p ${SERVER_DIR}/DDNet
  tar --directory ${SERVER_DIR}/DDNet --strip-components 1 -xf ${SERVER_DIR}/DDNet-${LAT_V}.tar.xz
  rm -rf ${SERVER_DIR}/DDNet-${LAT_V}.tar.xz
  touch ${SERVER_DIR}/installedv-${LAT_V}
elif [ "$LAT_V" == "$CUR_V" ]; then
  echo "---DDNet Version up-to-date---"
else
  echo "---Something went wrong, putting server in sleep mode---"
  sleep infinity
fi

echo "---Preparing Server---"
if [ ! -f ${SERVER_DIR}/autoexec.cfg ]; then
  cd ${SERVER_DIR}
  if wget -q -nc --show-progress --progress=bar:force:noscroll -O ${SERVER_DIR}/autoexec.cfg "https://raw.githubusercontent.com/ich777/docker-ddnet-server/master/config/autoexec.cfg" ; then
    echo "---Successfully downloaded 'autoexec.cfg'---"
  else
    echo "---Can't download 'autoexec.cfg', continuing...---"
  fi
fi
chmod -R ${DATA_PERM} ${DATA_DIR}

echo "---Starting Server---"
cd ${SERVER_DIR}/DDNet
${SERVER_DIR}/DDNet/DDNet-Server -f ${SERVER_DIR}/${GAME_CONFIG}