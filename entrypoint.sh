#!/bin/bash

## treat env vars

## hand of to CMD

echo "Copying ProfitTrailer's trading configuration to PTM as base..."
cp /mnt/profittrailer/trading/* /opt/pt-magic/ptm-binance/_presets/Default/

ping 10.10.0.1 >/dev/null 2>/dev/null
