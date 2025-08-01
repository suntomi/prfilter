#!/bin/bash
if [ -z "$1" ]; then
    echo "Usage: $0 <command>"
    exit 1
fi
COMMAND="$1"
DATA="$2"
if [ "${COMMAND}" = "match" ]; then
  author=$(echo "${DEPLO_MODULE_OPTION_STRING}" | jq -r '.author')
  input=$(echo "${DATA}" | jq -r '.event.pull_request.user.login')
  if [ "${input}" = "${author}" ]; then
    echo "{\"user\": \"${author}\"}"
    exit 0
  fi
fi
echo ""
