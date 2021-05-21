#!/bin/bash
set -x
set -e

echo Build docker image
docker build -t 942095822719.dkr.ecr.eu-west-2.amazonaws.com/kidsloop-ecr-token:latest .

echo Docker login and push
aws ecr get-login-password --region eu-west-2 | docker login --username AWS --password-stdin 942095822719.dkr.ecr.eu-west-2.amazonaws.com
docker push 942095822719.dkr.ecr.eu-west-2.amazonaws.com/kidsloop-ecr-token:latest
