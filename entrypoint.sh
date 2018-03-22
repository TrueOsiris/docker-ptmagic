#!/bin/bash

TZ=${TZ:-"Europe/Brussels"}
echo "Timezone set to $TZ"

echo "Copying ProfitTrailer's trading configuration to PTM as base"
cp -r /mnt/profittrailer/trading/* /opt/pt-magic/ptm-binance/_presets/Default/
if [ ! -f /mnt/ptmagic/settings.analyzer.json ]; then
  echo "no PTM settings found in /mnt/ptmagic"
  echo "Copying files from \"_default settings BTC or ETH\""
  cp -r /opt/pt-magic/ptm-binance/_default\ settings\ BTC\ or\ ETH/* /mnt/ptmagic/
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

echo "Replacing PT Magic base Path in Monitor/appsettings.json"
sed -i "s#YOUR PT MAGIC PATH#/opt/pt-magic/ptm-binance#g" /mnt/ptmagic/Monitor/appsettings.json
echo "Replacing PT base path in settings.general.json"
sed -i "s#YOUR PROFIT TRAILER PATH#/mnt/profittrailer#g" /mnt/ptmagic/settings.general.json

if [ -f /mnt/ptmagic/settings.secure.json ]; then
  echo "settings.secure.json exists in /mnt/ptmagic"
else
  echo "Creating settings.secure.json in /mnt/ptmagic"
  touch /mnt/ptmagic/settings.secure.json
fi
if [ -f /opt/pt-magic/ptm-binance/settings.secure.json ]; then
  echo "settings.secure.json exists in /opt/pt-magic/ptm-binance"
else 
  echo "Creating symlink to /mnt/ptmagic/settings.secure.json in /opt/pt-magic/ptm-binance"
  ln -s /mnt/ptmagic/settings.secure.json /opt/pt-magic/ptm-binance/settings.secure.json
fi

ping 10.10.0.1 >/dev/null 2>/dev/null
