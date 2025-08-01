#!/bin/bash

kubectl apply -f $1/deployment.yaml
kubectl apply -f $1/service.yaml