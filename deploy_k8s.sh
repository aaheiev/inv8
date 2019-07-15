#!/usr/bin/env bash

version=$(rake version)

kubectl -n jenkins set image deployment/ngs-inv8 jets=mydao/inv8:$version
kubectl -n jenkins rollout status deployment/inv8
