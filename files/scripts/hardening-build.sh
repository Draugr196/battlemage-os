#!/usr/bin/env bash

set -euo pipefail

authselect enable-feature with-faillock

sed -i 's/^#\s*\(auth\s\+required\s\+pam_wheel.so\s\+use_uid\)/\1/' /etc/pam.d/su
grep -Eq '^auth\s+required\s+pam_wheel.so\s+use_uid' /etc/pam.d/su

sed -i 's/^UMASK.*/UMASK\t\t027/' /etc/login.defs
grep -Eq '^UMASK\s+027' /etc/login.defs

sed -i 's/^LogDenied=.*/LogDenied=unicast/' /etc/firewalld/firewalld.conf
grep -qx 'LogDenied=unicast' /etc/firewalld/firewalld.conf
grep -qx 'DefaultZone=BattleStation' /etc/firewalld/firewalld.conf

sed -i 's/^max_log_file_action.*/max_log_file_action = ROTATE/; s/^space_left_action.*/space_left_action = SYSLOG/' /etc/audit/auditd.conf
dconf update
test -f /etc/dconf/db/local

echo "hardening-build.sh: done"
