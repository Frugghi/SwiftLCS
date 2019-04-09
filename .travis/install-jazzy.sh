#!/usr/bin/env bash

if [[ "${TRAVIS_OS_NAME}" == "osx" && "${GENERATE_DOC}" == "YES" ]]; then
  gem install jazzy --no-document --quiet
fi
