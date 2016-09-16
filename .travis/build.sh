#!/usr/bin/env bash

set -o pipefail

function build_osx {
  xcodebuild -workspace "${WORKSPACE}" -scheme "$2" -sdk "${SDK}" -destination "${DESTINATION}" -configuration "$1" ONLY_ACTIVE_ARCH=NO "${@:3}" | xcpretty -c;
}

function build_linux {
  swift build --configuration "$1"
}

ARGS=()
if [ "${RUN_TESTS}" == "YES" ]; then
  ARGS+=(ENABLE_TESTABILITY=YES test)
fi

if [[ "${TRAVIS_OS_NAME}" == "osx" ]]; then
  build_osx "$1" "$2" "${ARGS[@]}"
elif [[ "${TRAVIS_OS_NAME}" == "linux" ]]; then
  build_linux "$1"
else
  echo "Unknown OS: ${TRAVIS_OS_NAME}"
  exit 1
fi
