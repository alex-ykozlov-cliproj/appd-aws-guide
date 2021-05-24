#!/usr/bin/env bash

export IMAGE_NAME=ghcr.io/alex-ykozlov-cliproj/appd-aws-ingestion/appd-aws-ingestion:1.0.0


docker build -t ${IMAGE_NAME} -f Dockerfile ./src