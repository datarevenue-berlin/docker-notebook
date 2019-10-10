#!/usr/bin/env bash

docker build -t drtools/notebook:kernelspec kernelspecs
docker build -t drtools/notebook:base-kernel kernel-containers/standard/
docker build -t drtools/notebook:2.0.0 notebook-container

docker push drtools/notebook:kernelspec
docker push drtools/notebook:base-kernel
docker build -t drtools/notebook:2.0.0


helm install stable/nfs-server-provisioner \
    --name nfs-server \
    -f nfs/config.yaml

helm install \
    --name enterprise-gateway \
    --namespace enterprise-gateway https://github.com/jupyter/enterprise_gateway/releases/download/v2.0.0/jupyter_enterprise_gateway_helm-2.0.0.tgz \
    -f gateway/config.yaml
