## Introduction

A Docker image which uses for a cronjob inside K8S Cluser that keeps ECR pull credentials fresh.

This repo only contains the Dockerfile, init script for the Docker image, 
all the variables & volume are configured by helm chart repo

## Environment Variables & Volume Mount

The init script of this image requires some variables to run:

- NAMESPACE and SECRET_NAME of the secret that the cronjob manages
- CREDENTIAL_SECRET_NAME the credential source that the cronjob uses to get docker login token
- some AWS info such as account id & region of the ECR repos  

A preview for helm chart configuration of this cronjob:

```
              env:
                - name: NAMESPACE
                  value: {{ .Release.Namespace }}
                - name: SECRET_NAME
                  value: {{.Values.secret_name}}                
                - name: CREDENTIAL_SECRET_NAME
                  value: {{.Values.credential_secret_name}} 
                - name: AWS_REGION
                  value: {{.Values.aws_region}}
                - name: AWS_ACCOUNT_ID
                  value: "{{.Values.aws_account_id}}"   
```                
```
  - name: ecr-token-infra
    namespace: {{ .Values.k8s_namespace_kidsloop }}
    chart: ../charts/ecr-token
    version: ~0.1.0
    condition: helm_ecr_token_infra.enabled
    values:
      - suffix: "-infra"
      - secret_name: "ecr-registry-infra"
      - credential_secret_name: "ecr-credentials-infra-pull"       
      - aws_region: "eu-west-2"
      - aws_account_id: "942095822719"
      - image: {{ .Values.ecr_token_infra_repository }}
      - image_pull_secret: "ecr-registry-infra"
```      