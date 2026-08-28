#!/usr/bin/env bash
# BlueBuild "script" module: bake the Squared theme into LibreWolf itself.
# Patches browser/omni.ja at IMAGE BUILD TIME by appending our CSS (with the
# SVG icons inlined as data: URIs) to the browser's own skin stylesheet.
# Nothing runs on the user's machine: no autoconfig, no prefs, no profile
# writes. Re-applies automatically on every image rebuild.
set -euo pipefail

SRC="/usr/share/squared-librewolf"
MARKER="Squared GTK theme"

# --- Locate the LibreWolf install dir --------------------------------------
LIBDIR=""
for d in /usr/lib64/librewolf /usr/lib/librewolf /opt/librewolf; do
    [[ -f "$d/browser/omni.ja" ]] && { LIBDIR="$d"; break; }
done
if [[ -z "$LIBDIR" ]]; then
    OMNI_FOUND="$(find /usr /opt -maxdepth 4 -path '*librewolf*/browser/omni.ja' -print -quit 2>/dev/null || true)"
    [[ -n "$OMNI_FOUND" ]] && LIBDIR="$(dirname "$(dirname "$OMNI_FOUND")")"
fi
if [[ -z "$LIBDIR" ]]; then
    echo "ERROR: LibreWolf browser/omni.ja not found — dnf module must run before this script." >&2
    exit 1
fi
OMNI="$LIBDIR/browser/omni.ja"
echo "Patching: $OMNI"

# --- Sanity check payload ---------------------------------------------------
for f in squared.css squared/close.svg squared/close_prelight.svg squared/close_unfocused.svg \
         squared/maximize.svg squared/maximize_prelight.svg squared/min.svg squared/min_prelight.svg; do
    [[ -f "$SRC/$f" ]] || { echo "ERROR: missing $SRC/$f — did the files module run first?" >&2; exit 1; }
done

# --- Inline SVGs into the CSS, append to browser.css inside omni.ja ---------
python3 - "$OMNI" "$SRC" "$MARKER" <<'PYEOF'
import base64, re, shutil, sys, zipfile

omni_path, src, marker = sys.argv[1], sys.argv[2], sys.argv[3]

# Build the CSS payload with data: URI icons (no external files needed)
css = open(f"{src}/squared.css").read()
def inline(m):
    name = m.group(1)
    data = base64.b64encode(open(f"{src}/squared/{name}.svg", "rb").read()).decode()
    return f'url("data:image/svg+xml;base64,{data}")'
css = re.sub(r'url\("squared/([a-z_]+)\.svg"\)', inline, css)
payload = f"\n\n/* ==== {marker} (baked in at image build) ==== */\n{css}\n/* ==== end {marker} ==== */\n"

# Find the browser skin stylesheet inside omni.ja
zin = zipfile.ZipFile(omni_path, "r")
target = None
for n in zin.namelist():
    if n.endswith("skin/classic/browser/browser.css"):
        target = n
        break
if target is None:
    sys.exit("ERROR: browser.css not found inside omni.ja — LibreWolf layout changed; aborting build so this fails loudly.")

existing = zin.read(target).decode("utf-8")
if marker in existing:
    print("Theme already present in omni.ja; nothing to do.")
    zin.close()
    sys.exit(0)

# Rewrite the archive with the patched stylesheet
new_path = omni_path + ".new"
with zipfile.ZipFile(new_path, "w", zipfile.ZIP_DEFLATED) as zout:
    for info in zin.infolist():
        data = zin.read(info.filename)
        if info.filename == target:
            data = existing.encode("utf-8") + payload.encode("utf-8")
        zout.writestr(info, data)
zin.close()
shutil.move(new_path, omni_path)
print(f"Appended Squared CSS to {target} ({len(payload)} bytes)")
PYEOF

# New mtime on omni.ja makes Firefox discard any stale startup cache
touch "$OMNI" "$LIBDIR/browser"

echo "Squared theme baked into LibreWolf."
