#!/bin/bash

kubectl delete deployment $1 -n microservices
kubectl delete service $1 -n microservices