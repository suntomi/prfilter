#!/bin/sh
set -eo pipefail
TYPE="$1"
COMMAND="$2"
# log to stderr
echo "${TYPE} ${COMMAND}" >&2
if [ "${COMMAND}" = "filter_event" ]; then
  EVENT="$3"
  author=$(printf '%s' "${DEPLO_MODULE_OPTION_STRING}" | jq -r '.author // ""')
  if [ -z "${author}" ]; then
    echo "No author specified, match all authors" >&2
    author=".*"
  fi
  echo "author: [${author}]" >&2
  input=$(printf '%s' "${EVENT}" | jq -r '.event.pull_request.user.login // ""')
  echo "author from input: [${input}]" >&2
  if [ -z "${input}" ]; then
    echo "fatal: No author found in input" >&2
    exit 1
  fi
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
  user=$(printf '%s' "${CONTEXT}" | jq -r '.user // ""')
  expect=$(printf '%s' "${CONDITION}" | jq -r '.user // ""')
  echo "user: [${user}]" >&2
  echo "expect: [${expect}]" >&2
  if [ -z "${expect}" ]; then
    echo "fatal: No expect user configuration" >&2
    exit 1
  fi
  if [[ "${user}" =~ ${expect} ]]; then
    echo "match"
    exit 0
  fi
fi
echo ""
