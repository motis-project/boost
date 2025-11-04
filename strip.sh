#!/bin/bash

find libs -path "*/doc/*" -delete
find libs -type f -name 'Jamfile.v2' -delete
find libs -type f \
          -not -path "*/src/*" \
          -not -path "*/cmake/*" \
          -not -path "*/config/*" \
          -not -path "*/build/*" \
          -not -regex "libs/[^/]+/CMakeLists\.txt" \
          -delete
find libs -empty -type d -delete

for dir in libs/*/; do
    if [ ! -d "${dir}/src/" ]; then
        rm -r "${dir}"
    fi
done
