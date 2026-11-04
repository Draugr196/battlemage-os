#!/usr/bin/env bash
# Install the Selkies SELinux module into the image's policy, so Caddy
# (httpd_t) may reach the login helper and users' desktop sockets.
# -n: build the policy but don't try to load it into the build host's kernel.
set -euo pipefail
semodule -n -i /usr/share/selinux/packages/selkies/selkies.cil
semodule -l | grep -qx selkies
echo "SELinux module 'selkies' installed"
