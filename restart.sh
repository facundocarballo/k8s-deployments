#!/bin/bash

kubectl rollout restart deployment $1 -n microservices