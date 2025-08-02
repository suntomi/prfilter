#!/bin/sh
set -eo pipefail
TYPE="$1"
COMMAND="$2"
# log to stderr
echo "${TYPE} ${COMMAND}" >&2
if [ "${COMMAND}" = "filter_event" ]; then
  EVENT="$3"
  author=$(printf '%s' "${DEPLO_MODULE_OPTION_STRING}" | jq -r '.author')
  echo "author: ${author}" >&2
  if [ -z "${author}" ]; then
    echo "No author specified, match all authors" >&2
    author=".*"
  fi
  input=$(printf '%s' "${EVENT}" | jq -r '.event.pull_request.user.login')
  echo "author from input: ${input}" >&2
  # author can be regex
  if [[ "${input}" =~ ${author} ]]; then
    echo "{\"user\": \"${input}\"}"
    exit 0
  fi
elif [ "${COMMAND}" = "filter_context" ]; then
  CONTEXT="$3"
  CONDITION="$4"
  echo "context: ${CONTEXT}" >&2
  echo "condition: ${CONDITION}" >&2
  user=$(printf '%s' "${CONTEXT}" | jq -r '.user')
  expectation=$(printf '%s' "${CONDITION}" | jq -r '.user')
  if [ "${user}" = "${expectation}" ]; then
    echo "match"
    exit 0
  fi
fi
echo ""
