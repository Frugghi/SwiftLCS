#!/usr/bin/env bash

if [[ "${TRAVIS_OS_NAME}" == "osx" ]]; then
  gem install cocoapods --no-document --quiet
fi
