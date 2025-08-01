#!/bin/bash

kubectl delete deployment $1 -n default
kubectl delete service $1 -n default