#!/usr/bin/env bash
set -euo pipefail

chmod 0755 /usr/libexec/selkies-*

fail=0
need() { if ! eval "$2" >/dev/null 2>&1; then echo "MISSING: $1" >&2; fail=1; else echo "ok: $1"; fi; }

echo "== web desktop pieces"
need "GDM headless sessions (GDM 50+)"        "test -f /usr/lib/systemd/system/gnome-headless-session@.service"
need "gnome-shell user unit"                  "test -f /usr/lib/systemd/user/org.gnome.Shell@.service"
need "gnome-shell binary"                     "test -x /usr/bin/gnome-shell"
need "selkies"                                "test -x /usr/bin/selkies"
need "selkies-proxy runnable by users"        "su -s /bin/sh nobody -c 'test -r /usr/libexec/selkies-proxy -a -x /usr/libexec/selkies-proxy'"
need "consent unit allows wheel"              "grep -qx 'ConditionGroup=|wheel' /usr/lib/systemd/user/selkies-consent.service"
need "selkies --unix-socket support"          "/usr/bin/selkies --help | grep -q -- --unix-socket"
need "caddy"                                  "command -v caddy"
need "libpam (for selkies-pam-auth)"          "python3 -c 'import ctypes.util,sys; sys.exit(not ctypes.util.find_library(\"pam\"))'"
need "selkies-pam-auth compiles"              "python3 -I -c 'import ast,sys; ast.parse(open(sys.argv[1]).read())' /usr/libexec/selkies-pam-auth"
need "PyGObject + AT-SPI (consent helper)"    "python3 -c 'import gi; gi.require_version(\"Atspi\",\"2.0\"); from gi.repository import Atspi'"
need "SELinux module 'selkies' installed"     "semodule -l | grep -qx selkies"
need "socket dirs labeled selkies_run_t"      "matchpathcon /run/selkies-auth/auth.sock /run/selkies/x.sock | grep -c selkies_run_t | grep -qx 2"
need "caddy confined as httpd_t (module targets it)" "matchpathcon /usr/bin/caddy | grep -q httpd_exec_t"
need "Fedora's headless login helper present"   "test -x /usr/libexec/gdm-headless-login-session"
need "...labeled xdm_exec_t (runs as GDM)"      "matchpathcon /usr/libexec/gdm-headless-login-session | grep -q xdm_exec_t"

echo "== web sign-in (PAM)"
need "pam_faillock module"                    "test -f /usr/lib64/security/pam_faillock.so"
need "pam_unix module"                        "test -f /usr/lib64/security/pam_unix.so"
need "/etc/pam.d/selkies uses its own faillock state" "grep -q 'conf=/etc/security/faillock-selkies.conf' /etc/pam.d/selkies"
need "/etc/pam.d/selkies does not include password-auth" "! grep -q 'include.*password-auth' /etc/pam.d/selkies"
need "faillock-selkies.conf has a private dir" "grep -Eq '^dir *= */run/selkies-auth/faillock' /etc/security/faillock-selkies.conf"
need "faillock enabled for console/SSH logins (hardening-build.sh ran)" "grep -q pam_faillock /etc/pam.d/password-auth"

echo "== hardening the web desktop relies on"
need "firewalld default zone is BattleStation"   "grep -qx 'DefaultZone=BattleStation' /etc/firewalld/firewalld.conf"
need "BattleStation zone file present"           "test -f /etc/firewalld/zones/BattleStation.xml"
need "dconf system db compiled (hardening-build.sh ran)" "test -f /etc/dconf/db/local"
need "dconf keeps lock-enabled mandatory"        "grep -qx '/org/gnome/desktop/screensaver/lock-enabled' /etc/dconf/db/local.d/locks/00-hardening"
need "sshd hardening sorts before 50-redhat.conf" "test -f /etc/ssh/sshd_config.d/00-hardening.conf -a ! -e /etc/ssh/sshd_config.d/99-hardening.conf"
need "sshd: X11Forwarding no in 00-hardening"    "grep -qix 'X11Forwarding no' /etc/ssh/sshd_config.d/00-hardening.conf"
need "aide installed (aide-init/aide-check units)" "rpm -q aide"

exit $fail
