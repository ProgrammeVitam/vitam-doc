#!/bin/bash

rm -rf build

docker build -t vitam-sphinx docker

docker run --user $(id -u):$(id -g) --rm -v $(pwd):/docs vitam-sphinx sphinx-multiversion source build/html

docker run --user $(id -u):$(id -g) --rm -v $(pwd):/docs vitam-sphinx sphinx-build -M latexpdf source build