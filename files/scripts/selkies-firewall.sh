#!/usr/bin/env bash
set -euo pipefail

firewall-offline-cmd --add-service=https
firewall-offline-cmd --add-port=8445/udp
firewall-offline-cmd --add-port=8445/tcp
