#!/bin/sh
TYPE="$1"
COMMAND="$2"
DATA="$3"
if [ "${COMMAND}" = "match" ]; then
  author=$(echo "${DEPLO_MODULE_OPTION_STRING}" | jq -r '.author')
  input=$(echo "${DATA}" | jq -r '.event.pull_request.user.login')
  if [ "${input}" = "${author}" ]; then
    echo "{\"user\": \"${author}\"}"
    exit 0
  fi
fi
echo ""
