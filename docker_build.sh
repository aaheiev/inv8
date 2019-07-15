#!/usr/bin/env bash

version=$(rake version)

docker build -t mydao/inv8:$version .
docker push mydao/inv8:$version
