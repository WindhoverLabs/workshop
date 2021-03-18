#!/bin/bash
#This script assumes that build_image.sh has been called.

PRG="$0"
YAMCS_HOME="$1"
WORKSPACE_PATH="$2"
CONTAINER_NAME="$3"

IMAGE_NAME="viper:yamcs"
YAMCS_ROOT="/yamcs"
START_YAMCS="start_yamcs.sh"
START_YAMCS_IN_CONATINER=$YAMCS_ROOT/$START_YAMCS

# Create Volume and container
CONTAINER_ID=$(docker run -dit -P --name "$CONTAINER_NAME" -v "$YAMCS_HOME":"$YAMCS_ROOT" "$IMAGE_NAME")

docker cp "$WORKSPACE_PATH" "$CONTAINER_ID":$YAMCS_ROOT
docker cp start_yamcs.sh "$CONTAINER_ID":$YAMCS_ROOT

CONTAINER_WORKSPACE="$YAMCS_ROOT/$(basename "$WORKSPACE_PATH")"

DOCKER_COMMAND="$START_YAMCS_IN_CONATINER $YAMCS_ROOT $CONTAINER_WORKSPACE"

docker exec -it "$CONTAINER_ID"  /bin/sh -c "$DOCKER_COMMAND"
