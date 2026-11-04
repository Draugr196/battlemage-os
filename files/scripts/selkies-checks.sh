#!/usr/bin/env bash
# Build-time checks for per-user Selkies desktops. Each missing piece fails
# the build here, instead of a desktop silently never starting later.
set -euo pipefail
fail=0
need() { if ! eval "$2" >/dev/null 2>&1; then echo "MISSING: $1" >&2; fail=1; else echo "ok: $1"; fi; }

need "GDM headless sessions (GDM 50+)"        "test -f /usr/lib/systemd/system/gnome-headless-session@.service"
need "gnome-shell user unit"                  "test -f /usr/lib/systemd/user/org.gnome.Shell@.service"
need "gnome-shell binary"                     "test -x /usr/bin/gnome-shell"
need "selkies"                                "test -x /usr/bin/selkies"
need "selkies --unix-socket support"          "/usr/bin/selkies --help | grep -q -- --unix-socket"
need "caddy"                                  "command -v caddy"
need "libpam (for selkies-pam-auth)"          "python3 -c 'import ctypes.util,sys; sys.exit(not ctypes.util.find_library(\"pam\"))'"
need "PyGObject + AT-SPI (consent helper)"    "python3 -c 'import gi; gi.require_version(\"Atspi\",\"2.0\"); from gi.repository import Atspi'"
need "password-auth PAM stack"                "test -e /etc/pam.d/password-auth"
need "SELinux module 'selkies' installed"     "semodule -l | grep -qx selkies"
need "socket dirs labeled selkies_run_t"      "matchpathcon /run/selkies-auth/auth.sock /run/selkies/x.sock | grep -c selkies_run_t | grep -qx 2"
need "caddy confined as httpd_t (module targets it)" "matchpathcon /usr/bin/caddy | grep -q httpd_exec_t"

exit $fail
