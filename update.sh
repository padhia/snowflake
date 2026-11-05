#!/usr/bin/env bash
set -euo pipefail

# Packages that nix-update can auto-detect versions for (PyPI / GitHub)
packages=(
  snowflake-cli
  snowflake-connector-python
  snowflake-core
  snowflake-snowpark-python
  snowflake-ml-python
  modin
  snowpark-connect
)

# Skipped:
#   snowsql        - fetches RPMs from a custom URL, not a recognized registry
#   protoc-wheel-0 - platform-specific wheel with per-arch hashes
#   snowflake-connector-python5 - per-platform/per-python wheels; handled by update_connector5 below

for pkg in "${packages[@]}"; do
  echo ">>> Updating $pkg"
  nix run nixpkgs#nix-update -- --flake "$pkg" "$@" || echo "  !! $pkg update failed, skipping"
done

# Regenerate version and per-platform/per-python wheel hashes for connector 5.x from PyPI metadata
update_connector5() {
  local nix_file
  nix_file="$(dirname "$0")/snowflake-connector-python5.nix"
  python3 - "$nix_file" <<'EOF'
import base64, json, re, sys, urllib.request

path = sys.argv[1]
base = "https://pypi.org/pypi/snowflake-connector-python"

def fetch(url):
    with urllib.request.urlopen(url) as r:
        return json.load(r)

def vkey(v):
    return tuple(int(x) for x in v.split("."))

releases = fetch(f"{base}/json")["releases"]
version = max((v for v in releases if re.fullmatch(r"5\.\d+\.\d+", v)), key=vkey)

src = open(path).read()
current = re.search(r'version = "([^"]+)";', src).group(1)
if current == version:
    print(f"  snowflake-connector-python5 already at {version}")
    sys.exit(0)

def nix_system(plat):
    arch = "x86_64" if plat.endswith("x86_64") else "aarch64" if plat.endswith(("aarch64", "arm64")) else None
    os_ = "linux" if plat.startswith("manylinux") else "darwin" if plat.startswith("macosx") else None
    return f"{arch}-{os_}" if arch and os_ else None

platforms = {}
for u in fetch(f"{base}/{version}/json")["urls"]:
    m = re.fullmatch(r"snowflake_connector_python-[^-]+-(cp\d+)-(cp\d+)-(.+)\.whl", u["filename"])
    if not m or m.group(1) != m.group(2):  # skip free-threaded (cp314t) and abi3 wheels
        continue
    system = nix_system(m.group(3))
    if system is None:
        continue
    sri = "sha256-" + base64.b64encode(bytes.fromhex(u["digests"]["sha256"])).decode()
    platforms.setdefault(system, {})[m.group(1)] = (m.group(3), sri)

order = ["x86_64-linux", "aarch64-linux", "x86_64-darwin", "aarch64-darwin"]
lines = ["  platforms = {"]
for system in order:
    if system not in platforms:
        continue
    lines.append(f"    {system} = {{")
    for tag in sorted(platforms[system], key=lambda t: int(t[2:])):
        plat, sri = platforms[system][tag]
        lines.append(f'      {tag} = {{ platform = "{plat}"; hash = "{sri}"; }};')
    lines.append("    };")
lines.append("  };")

src = re.sub(r'version = "[^"]+";', f'version = "{version}";', src, count=1)
src = re.sub(r"  platforms = \{\n.*?\n  \};", lambda _: "\n".join(lines), src, count=1, flags=re.S)
open(path, "w").write(src)
print(f"  snowflake-connector-python5: {current} -> {version}")
EOF
}

echo ">>> Updating snowflake-connector-python5"
update_connector5 || echo "  !! snowflake-connector-python5 update failed, skipping"
