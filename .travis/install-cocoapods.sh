#!/usr/bin/env bash

if [[ "${TRAVIS_OS_NAME}" == "osx" ]]; then
  gem install cocoapods --no-rdoc --no-ri --no-document --quiet
fi
