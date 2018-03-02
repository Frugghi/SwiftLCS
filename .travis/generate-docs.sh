#!/usr/bin/env bash

if [[ "${GENERATE_DOC}" != "YES" ]]; then
  exit 0
fi

jazzy \
  --clean \
  --podspec "${PODSPEC_PATH}" \
  --output "docs/"
