#!/bin/bash

FOLDER_PATH=deployments/$1
KUSTOMIZATION_FILE_PATH=$FOLDER_PATH/kustomization.yaml
VARIABLES_PROPERTIES_FILE_PATH=$FOLDER_PATH/variables.properties

if [ ! -f $KUSTOMIZATION_FILE_PATH ]; then
    mkdir -p $FOLDER_PATH
    touch $KUSTOMIZATION_FILE_PATH
fi

if [ ! -f $VARIABLES_PROPERTIES_FILE_PATH ]; then
    mkdir -p $FOLDER_PATH
    touch $VARIABLES_PROPERTIES_FILE_PATH
fi

cat <<EOF > "$KUSTOMIZATION_FILE_PATH"
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
namespace: microservices
resources:
- ../../base
configMapGenerator:
- envs:
  - variables.properties
  name: $1
  options:
    disableNameSuffixHash: true
patches:
  # Patch Deployment
  - target:
      kind: Deployment
      name: ms
    patch: |-
      - op: replace
        path: /metadata/name
        value: $1
      - op: replace
        path: /spec/selector/matchLabels/app
        value: $1
      - op: replace
        path: /spec/template/metadata/labels/app
        value: $1
      - op: replace
        path: /spec/template/spec/containers/0/name
        value: $1
      - op: replace
        path: /spec/template/spec/containers/0/image
        value: $1:latest
  
  # Patch Service
  - target:
      kind: Service
      name: ms
    patch: |-
      - op: replace
        path: /metadata/name
        value: $1
      - op: replace
        path: /spec/selector/app
        value: $1

  # Patch HPA
  - target:
      kind: HorizontalPodAutoscaler
      name: ms
    patch: |-
      - op: replace
        path: /metadata/name
        value: $1
      - op: replace
        path: /spec/scaleTargetRef/name
        value: $1
      - op: replace
        path: /spec/minReplicas
        value: 1
      - op: replace
        path: /spec/maxReplicas
        value: 3
EOF