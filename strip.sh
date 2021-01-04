#!/bin/bash

find libs -name doc* -type d -exec rm {} \;
find . -not -name boost -not -name libs -maxdepth 1 -exec rm {} \;
find libs -type f -not -wholename "*src/*" -delete
find libs -empty -type d -delete