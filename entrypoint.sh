#!/bin/bash

TZ=${TZ:-"Europe/Brussels"}
echo "Timezone set to $TZ"
PARAM=${1:-"PTMagic.dll"}
echo "Parameter $PARAM passed to entrypoint.sh"

echo "Copying ProfitTrailer's trading configuration to PTM as base"
cp -r /mnt/profittrailer/trading/* /opt/pt-magic/ptm-binance/_presets/Default/
if [ ! -f /mnt/ptmagic/settings.analyzer.json ]; then
  echo "no PTM settings found in /mnt/ptmagic"
  echo "Copying files from \"_default settings BTC or ETH\""
  #cp -r /opt/pt-magic/ptm-binance/_default\ settings\ BTC\ or\ ETH/* /mnt/ptmagic/
  cp -r /opt/pt-magic/ptm-binance/_default\ settings\ PT\ 1.x/_default\ settings\ BTC\ or\ ETH/* /mnt/ptmagic/
fi
echo "Setting rw rights on files in /mnt/ptmagic"
chmod -R 666 /mnt/ptmagic/*
echo "Creating symlink to /mnt/ptmagic/Monitor/appsettings.json in /opt/pt-magic/ptm-binance/Monitor"
ln -s /mnt/ptmagic/Monitor/appsettings.json /opt/pt-magic/ptm-binance/Monitor/appsettings.json
echo "Creating symlink to /mnt/ptmagic/settings.analyzer.json in /opt/pt-magic/ptm-binance"
ln -s /mnt/ptmagic/settings.analyzer.json /opt/pt-magic/ptm-binance/settings.analyzer.json
echo "Creating symlink to /mnt/ptmagic/settings.general.json in /opt/pt-magic/ptm-binance"
ln -s /mnt/ptmagic/settings.general.json /opt/pt-magic/ptm-binance/settings.general.json
echo "Creating symlink to /mnt/ptmagic/nlog.config in /opt/pt-magic/ptm-binance"
ln -s /mnt/ptmagic/nlog.config /opt/pt-magic/ptm-binance/nlog.config

echo "Replacing PT Magic base Path in Monitor/appsettings.json with /opt/pt-magic/ptm-binance if it's still the default setting"
sed -i "s#YOUR PT MAGIC PATH#/opt/pt-magic/ptm-binance#g" /mnt/ptmagic/Monitor/appsettings.json
echo "Replacing PT base path in settings.general.json with /mnt/profittrailer if it's still the default setting"
sed -i "s#YOUR PROFIT TRAILER PATH#/mnt/profittrailer#g" /mnt/ptmagic/settings.general.json

if [ -f /mnt/ptmagic/settings.secure.json ]; then
  echo "settings.secure.json exists in /mnt/ptmagic"
else
  echo "Creating empty settings.secure.json in /mnt/ptmagic"
  cat > /mnt/ptmagic/settings.secure.json <<- "EOF"
  {
   "SecureSettings": {
    "MonitorPassword": ""
   }
  }
EOF
fi
if [ -f /opt/pt-magic/ptm-binance/settings.secure.json ]; then
  echo "settings.secure.json exists in /opt/pt-magic/ptm-binance"
  mv /opt/pt-magic/ptm-binance/settings.secure.json /mnt/ptmagic/
  ln -s /mnt/ptmagic/settings.secure.json /opt/pt-magic/ptm-binance/settings.secure.json
else 
  echo "Creating symlink to /mnt/ptmagic/settings.secure.json in /opt/pt-magic/ptm-binance"
  ln -s /mnt/ptmagic/settings.secure.json /opt/pt-magic/ptm-binance/settings.secure.json
fi

### get _data to volume for separate monitor container ###
if [ -d "/opt/pt-magic/ptm-binance/_data" ]; then
  echo "/opt/pt-magic/ptm-binance/_data exists"
  if [ -L "/opt/pt-magic/ptm-binance/_data" ]; then
    if [ -d "/mnt/ptmagic/_data" ]; then 
      echo "/mnt/ptmagic/_data exists"
      echo "/opt/pt-magic/ptm-binance/_data is a symlink, which is good"
    else 
      echo "/mnt/ptmagic/_data does not exist"
      echo "/opt/pt-magic/ptm-binance/_data is a symlink, which is NOT good, since /mnt/ptmagic/_data is not there"
    fi 
    ls -hl /opt/pt-magic/ptm-binance/ | grep data
  else
    echo "/opt/pt-magic/ptm-binance/_data is a directory. Moving to volume, removing original, creating symlink"
    mv /opt/pt-magic/ptm-binance/_data /mnt/ptmagic/
    rm -R /opt/pt-magic/ptm-binance/_data
    ln -s /mnt/ptmagic/_data /opt/pt-magic/ptm-binance/_data
  fi
else
  echo "/opt/pt-magic/ptm-binance/_data does not exist (yet, at container start)"
  if [ -d "/mnt/ptmagic/_data" ]; then 
    echo "/mnt/ptmagic/_data exists"
  else 
    echo "/mnt/ptmagic/_data does not exist"
    echo "creating directory /mnt/ptmagic/_data"
    mkdir /mnt/ptmagic/_data
  fi
  echo "Creating symlink from /mnt/ptmagic/_data to /opt/pt-magic/ptm-binance/_data"
  ln -s /mnt/ptmagic/_data /opt/pt-magic/ptm-binance/_data
fi
chmod -R 666 /mnt/ptmagic/*

cd /opt/pt-magic/ptm-binance
echo "Executing \"dotnet $PARAM\""
dotnet $PARAM

#ping 10.10.0.1 >/dev/null 2>/dev/null
