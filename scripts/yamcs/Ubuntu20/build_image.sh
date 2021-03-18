#!/bin/bash

IMAGE_NAME=$1

#Build the image
docker build -t "$IMAGE_NAME" .