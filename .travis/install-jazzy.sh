#!/usr/bin/env bash

if [[ "${TRAVIS_OS_NAME}" == "osx" && "${GENERATE_DOC}" == "YES" ]]; then
  gem install jazzy --no-rdoc --no-ri --no-document --quiet
fi
