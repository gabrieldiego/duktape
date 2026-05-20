#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
NETSURF_ROOT="${NETSURF_ROOT:-${ROOT}/../netsurf}"
DIST_DIR="${DIST_DIR:-${ROOT}/dist/source}"
TARGET_DIR="${TARGET_DIR:-${NETSURF_ROOT}/content/handlers/javascript/duktape}"
NODE_BIN="${NODE_BIN:-node}"

usage() {
	cat <<EOF
Usage:
  ${0##*/} [-- netsurf-root]

Build the Duktape source distributable and copy the vendored engine files
into the NetSurf checkout next to this repository.

Environment overrides:
  NETSURF_ROOT   Path to the NetSurf checkout (default: ${ROOT}/../netsurf)
  DIST_DIR       Dist source output directory (default: ${ROOT}/dist/source)
  TARGET_DIR     NetSurf Duktape directory (default: NETSURF_ROOT/content/handlers/javascript/duktape)

This script copies only:
  - duk_config.h
  - duktape.c
  - duktape.h
EOF
}

if [ "${1:-}" = "-h" ] || [ "${1:-}" = "--help" ]; then
	usage
	exit 0
fi

if [ "${1:-}" = "--" ] && [ "${2:-}" != "" ]; then
	NETSURF_ROOT="$2"
	TARGET_DIR="${NETSURF_ROOT}/content/handlers/javascript/duktape"
fi

if [ ! -d "${NETSURF_ROOT}" ]; then
	printf 'NetSurf root not found: %s\n' "${NETSURF_ROOT}" >&2
	exit 2
fi

rm -rf "${DIST_DIR}"
mkdir -p "${ROOT}/dist"

printf 'Building Duktape source distributable in %s\n' "${ROOT}" >&2
"${NODE_BIN}" "${ROOT}/src-tools/index.js" dist \
	--repo-directory "${ROOT}" \
	--output-directory "${DIST_DIR}"

if [ ! -d "${DIST_DIR}/src" ]; then
	printf 'Expected dist source tree not found: %s/src\n' "${DIST_DIR}" >&2
	exit 2
fi

mkdir -p "${TARGET_DIR}"

for file in duk_config.h duktape.c duktape.h; do
	src="${DIST_DIR}/src/${file}"
	dst="${TARGET_DIR}/${file}"
	if [ ! -f "${src}" ]; then
		printf 'Missing generated file: %s\n' "${src}" >&2
		exit 2
	fi
	cp "${src}" "${dst}"
	printf 'Copied %s -> %s\n' "${src}" "${dst}" >&2
done
