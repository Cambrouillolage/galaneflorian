#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

errors=0
warnings=0

ok() { echo "[OK] $1"; }
warn() { echo "[WARN] $1"; warnings=$((warnings + 1)); }
err() { echo "[ERROR] $1"; errors=$((errors + 1)); }

check_required_files() {
  echo "== Verification des fichiers requis =="
  local required=(
    "index.html"
    "mariage_premium_site.html"
    "DEPLOYMENT.md"
    "README.md"
    "assets/favicon.png"
  )

  local file
  for file in "${required[@]}"; do
    if [[ -f "$file" ]]; then
      ok "$file present"
    else
      err "$file manquant"
    fi
  done
}

check_absolute_paths() {
  echo "== Verification des chemins absolus potentiellement cassants =="
  local matches
  matches="$(grep -nE '(src|href)="/[^"]+' index.html mariage_premium_site.html || true)"
  if [[ -n "$matches" ]]; then
    err "Chemins absolus detectes dans les HTML (a eviter pour GitHub Pages):"
    echo "$matches"
  else
    ok "Aucun chemin absolu local detecte"
  fi
}

check_local_references_exist() {
  echo "== Verification des references locales =="
  local html
  local line
  local raw
  local target
  local source
  local found=0

  while IFS='|' read -r source line raw; do
    [[ -z "$raw" ]] && continue
    target="$raw"
    target="${target%%\#*}"
    target="${target%%\?*}"

    if [[ -z "$target" ]]; then
      continue
    fi

    case "$target" in
      http://*|https://*|mailto:*|tel:*|javascript:*|data:*|\#*)
        continue
        ;;
    esac

    # Ignore les references construites dynamiquement via template literals JS.
    if [[ "$target" == *'$'*'{'* ]]; then
      continue
    fi

    if [[ ! -e "$target" ]]; then
      err "$source:$line -> reference introuvable: $raw"
      found=1
    fi
  done < <(
    awk '
      {
        while (match($0, /(src|href)="[^"]+"/)) {
          attr = substr($0, RSTART, RLENGTH)
          split(attr, kv, "\"")
          print FILENAME "|" NR "|" kv[2]
          $0 = substr($0, RSTART + RLENGTH)
        }
      }
    ' index.html mariage_premium_site.html
  )

  if [[ "$found" -eq 0 ]]; then
    ok "Toutes les references locales detectees existent"
  fi
}

check_assets_directories() {
  echo "== Verification des repertoires assets =="
  if [[ -d "assets/photos" ]]; then
    local photos_count
    photos_count="$(find assets/photos -maxdepth 1 -type f \( -name '*.jpg' -o -name '*.jpeg' -o -name '*.png' -o -name '*.webp' \) | wc -l)"
    if [[ "$photos_count" -ge 1 ]]; then
      ok "assets/photos contient $photos_count image(s)"
    else
      warn "assets/photos ne contient aucune image"
    fi
  else
    err "Repertoire assets/photos manquant"
  fi

  if [[ -d "assets/liste-mariage" ]]; then
    local gifts_count
    gifts_count="$(find assets/liste-mariage -maxdepth 1 -type f -name '*.jpg' | wc -l)"
    if [[ "$gifts_count" -ge 1 ]]; then
      ok "assets/liste-mariage contient $gifts_count image(s)"
    else
      warn "assets/liste-mariage ne contient aucune image .jpg"
    fi
  else
    err "Repertoire assets/liste-mariage manquant"
  fi
}

check_webhook() {
  echo "== Verification du webhook =="
  local webhook
  webhook="$(grep -E "const webhookUrl = '.*';" mariage_premium_site.html | sed -E "s/.*'([^']+)'.*/\1/" || true)"

  if [[ -z "$webhook" ]]; then
    err "webhookUrl non trouve dans mariage_premium_site.html"
    return
  fi

  if [[ "$webhook" == *"example.com"* || "$webhook" == *"placeholder"* ]]; then
    err "webhookUrl semble etre une valeur de test: $webhook"
    return
  fi

  ok "Webhook configure: $webhook"
}

main() {
  echo "Preflight MEP - site statique"
  echo "Repository: $ROOT_DIR"
  echo

  check_required_files
  echo
  check_absolute_paths
  echo
  check_local_references_exist
  echo
  check_assets_directories
  echo
  check_webhook
  echo

  if [[ "$errors" -gt 0 ]]; then
    echo "Resultat: ECHEC ($errors erreur(s), $warnings avertissement(s))"
    exit 1
  fi

  echo "Resultat: OK ($warnings avertissement(s))"
}

main "$@"
