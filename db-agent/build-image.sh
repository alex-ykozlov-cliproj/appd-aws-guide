#!/usr/bin/env bash

export IMAGE_NAME=ghcr.io/alex-ykozlov-cliproj/appd-aws-ingestion/appd-dbagent:21.2.0


docker build -t ${IMAGE_NAME} -f Dockerfile ./src