#!/bin/sh
set -eo pipefail
TYPE="$1"
COMMAND="$2"
DATA="$3"
# log to stderr
echo "${TYPE} ${COMMAND}" >&2
if [ "${COMMAND}" = "match" ]; then
  author=$(printf '%s' "${DEPLO_MODULE_OPTION_STRING}" | jq -r '.author')
  echo "author: ${author}" >&2
  input=$(printf '%s' "${DATA}" | jq -r '.event.pull_request.user.login')
  echo "author from input: ${input}" >&2
  if [ "${input}" = "${author}" ]; then
    echo "{\"user\": \"${author}\"}"
    exit 0
  fi
fi
echo ""
