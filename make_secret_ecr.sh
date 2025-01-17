#!/bin/sh
set +xeuo pipefail

# This script expects aws-cli-v2 to be installed.
# It will not work with aws-cli v1.18
NS_KIDSLOOP=$NAMESPACE

export AWS_DEFAULT_REGION=$AWS_REGION
export AWS_ACCESS_KEY_ID=$(kubectl get secret -n $NS_KIDSLOOP $CREDENTIAL_SECRET_NAME -o jsonpath='{.data.aws_access_key_id}' | base64 --decode)
export AWS_SECRET_ACCESS_KEY=$(kubectl get secret -n $NS_KIDSLOOP $CREDENTIAL_SECRET_NAME -o jsonpath='{.data.secret_access_key}' | base64 --decode)

kubectl create secret docker-registry $SECRET_NAME \
    --dry-run=client \
    -o yaml \
    -n $NS_KIDSLOOP \
    --docker-server="$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com" \
    --docker-username=AWS \
    --docker-password="$(aws ecr get-login-password)" \
    --docker-email="foo@bar.com" > ecr-secret.yaml

kubectl delete secret --ignore-not-found=true -n $NS_KIDSLOOP $SECRET_NAME
kubectl apply -f ecr-secret.yaml 

rm ecr-secret.yaml
