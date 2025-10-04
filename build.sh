#!/usr/bin/env bash
set -euo pipefail

# This script updates the version in pubspec.yaml (version: buildName+buildNumber),
# increments the build number by 1, and lets you set a new build name (SemVer),
# then runs `flutter build appbundle`.
# Usage:
#   ./build.sh                 # interactive prompt for new build name, keeps previous if empty
#   ./build.sh --non-interactive NEW_BUILD_NAME
# Notes:
#   - pubspec.yaml must contain a line starting with: version:
#   - Example format: version: 1.2.3+45

PROJECT_ROOT="$(cd "$(dirname "$0")" && pwd)"
PUBSPEC="$PROJECT_ROOT/pubspec.yaml"

err() { echo "[ERROR] $*" >&2; }
info() { echo "[INFO] $*"; }
success() { echo "[OK] $*"; }

if [[ ! -f "$PUBSPEC" ]]; then
  err "File not found: $PUBSPEC"
  exit 1
fi

# Read current version line
version_line=$(grep -E "^version:\s*" "$PUBSPEC" || true)
if [[ -z "$version_line" ]]; then
  err "Keine 'version:' Zeile in pubspec.yaml gefunden."
  exit 1
fi

# Extract build-name and build-number from 'version: name+number'
# Accept spaces: version: 1.2.3+4
raw_value=${version_line#version:}
raw_value=$(echo "$raw_value" | xargs) # trim
if [[ "$raw_value" =~ ^([^+]+)\+([0-9]+)$ ]]; then
  current_name="${BASH_REMATCH[1]}"
  current_number="${BASH_REMATCH[2]}"
else
  err "Unerwartetes Versionsformat: '$raw_value'. Erwartet z.B. '1.2.3+4'"
  exit 1
fi

if ! [[ "$current_number" =~ ^[0-9]+$ ]]; then
  err "Build-Nummer ist keine ganze Zahl: '$current_number'"
  exit 1
fi

new_number=$(( current_number + 1 ))

# Determine new build name (SemVer-like, but we accept any non-empty token)
non_interactive=false
provided_name=""
if [[ ${1:-} == "--non-interactive" ]]; then
  non_interactive=true
  provided_name=${2:-}
  if [[ -z "$provided_name" ]]; then
    err "--non-interactive benötigt ein Build-Name Argument, z.B. 1.2.4"
    exit 1
  fi
fi

if $non_interactive; then
  new_name="$provided_name"
else
  echo -n "Bitte neuen build-name (z.B. 1.2.4) eingeben (Leer lassen für bisherigen: $current_name): "
  read -r input_name
  if [[ -z "$input_name" ]]; then
    new_name="$current_name"
  else
    new_name="$input_name"
  fi
fi

# Basic validation: should look like A.B.C or similar; allow flexibility but disallow plus
if [[ "$new_name" =~ \+ ]]; then
  err "Build-Name darf kein '+' enthalten."
  exit 1
fi

# Backup and atomic write
backup_file="$PUBSPEC.bak.$(date +%Y%m%d%H%M%S)"
cp "$PUBSPEC" "$backup_file"
info "Backup erstellt: $backup_file"

tmp_file=$(mktemp)
cat "$PUBSPEC" > "$tmp_file"

# Replace version line
escaped_new="version: $new_name+$new_number"
sed -i "s/^version:\s*.*/$escaped_new/" "$tmp_file"

mv "$tmp_file" "$PUBSPEC"
success "pubspec.yaml aktualisiert: version: $new_name+$new_number"

# Verify flutter is available
if ! command -v flutter >/dev/null 2>&1; then
  err "Flutter CLI nicht gefunden. Bitte stellen Sie sicher, dass 'flutter' im PATH ist."
  exit 1
fi

# Ensure dependencies are up to date
info "Führe 'flutter pub get' aus..."
( cd "$PROJECT_ROOT" && flutter pub get )

# Build appbundle
info "Starte Build: flutter build appbundle"
( cd "$PROJECT_ROOT" && flutter build appbundle )

success "Build abgeschlossen. AppBundle befindet sich im build/ Ordner Ihrer Android-App."
