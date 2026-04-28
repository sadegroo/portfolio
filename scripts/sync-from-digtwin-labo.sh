#!/usr/bin/env bash
# ============================================================================
# Sync MATLAB screenshots from the digtwin_labo repo into this portfolio.
# digtwin_labo is the canonical source; this is a one-way pull (upstream → here).
# ============================================================================
#
# Convention: any file in <digtwin_labo>/docs/images/ prefixed `shared-*`
# is mirrored into the bldc-pendulum page bundle. Files without that prefix
# stay in digtwin_labo only and are not touched here.
#
# Usage:
#   bash scripts/sync-from-digtwin-labo.sh
#   bash scripts/sync-from-digtwin-labo.sh /alt/path/to/digtwin_labo
#   DIGTWIN_LABO=/alt/path bash scripts/sync-from-digtwin-labo.sh
#
# After running, review with:
#   git status content/posts/bldc-pendulum/
# ============================================================================

set -euo pipefail

UPSTREAM="${1:-${DIGTWIN_LABO:-/c/Users/u0130154/MATLAB/projects/digtwin_labo}}"
SRC="${UPSTREAM}/docs/images"
DST="content/posts/bldc-pendulum"

if [ ! -d "$SRC" ]; then
  echo "error: source directory not found: $SRC" >&2
  echo "  expected layout: <digtwin_labo>/docs/images/shared-*.png" >&2
  echo "  override path:   bash scripts/sync-from-digtwin-labo.sh /path/to/digtwin_labo" >&2
  echo "  or env var:      DIGTWIN_LABO=/path bash scripts/sync-from-digtwin-labo.sh" >&2
  exit 1
fi

if [ ! -d "$DST" ]; then
  echo "error: destination not found: $DST" >&2
  echo "  this script must run from the portfolio repo root" >&2
  exit 1
fi

echo "syncing shared-* assets"
echo "  from: $SRC"
echo "    to: $DST"
echo ""

# rsync with include/exclude pattern: only files starting with `shared-` are copied
rsync -av --include='shared-*' --exclude='*' "$SRC/" "$DST/"

echo ""
echo "done. review with: git status $DST"
