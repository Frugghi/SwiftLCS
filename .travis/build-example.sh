#!/usr/bin/env bash

set -o pipefail

function build_osx {
  xcodebuild -workspace "${WORKSPACE}" -scheme "$2" -sdk "${SDK}" -destination "${DESTINATION}" -configuration "$1" ONLY_ACTIVE_ARCH=NO | xcpretty -c;
}

if [[ "${BUILD_EXAMPLE}" != "YES" ]]; then
  exit 0
fi

if [[ "${TRAVIS_OS_NAME}" == "osx" ]]; then
  build_osx "$1" "$2"
fi
