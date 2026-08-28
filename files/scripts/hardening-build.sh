#!/usr/bin/env bash
set -euo pipefail

# Crypto policy: NO-SHA1 is safe; FUTURE breaks some Wi-Fi/VPNs, so it isn't used.
update-crypto-policies --set DEFAULT:NO-SHA1

# Account lockout after failed logins (config in /etc/security/faillock.conf)
authselect enable-feature with-faillock

# Only wheel may `su`
sed -i 's/^#\s*\(auth\s\+required\s\+pam_wheel.so\s\+use_uid\)/\1/' /etc/pam.d/su

# Default umask for new sessions
sed -i 's/^UMASK.*/UMASK\t\t027/' /etc/login.defs

# sudo refuses sudoers.d files that aren't 0440
chmod 0440 /etc/sudoers.d/hardening

# firewalld: log dropped unicast packets, keep FedoraWorkstation zone as-is
sed -i 's/^LogDenied=.*/LogDenied=unicast/' /etc/firewalld/firewalld.conf

# auditd log handling
sed -i 's/^max_log_file_action.*/max_log_file_action = ROTATE/; s/^space_left_action.*/space_left_action = SYSLOG/' /etc/audit/auditd.conf

# Compile dconf databases shipped in /etc/dconf/db/*.d
dconf update
