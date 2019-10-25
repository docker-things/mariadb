#!/bin/bash

# Command used to launch docker
DOCKER_CMD="`which docker`"

# Where to store the backups
BACKUP_PATH=""

# Where to store the communication pipes
FIFO_PATH="/tmp/docker-things/fifo"

# The name of the docker image
PROJECT_NAME="mariadb"

# BUILD ARGS
BUILD_ARGS=(
    )

# CREDENTIALS
MYSQL_ROOT_PASSWORD="password"
MYSQL_USER="user"
MYSQL_PASSWORD="password"
MYSQL_DATABASE="user_db"

# LAUNCH ARGS
RUN_ARGS=(
    --memory="1g"
    --cpu-shares=1024

    -p 3306:3306

    -v $(pwd)/data/db:/var/lib/mysql

    -e MYSQL_ROOT_PASSWORD="$MYSQL_ROOT_PASSWORD"
    -e MYSQL_USER="$MYSQL_USER"
    -e MYSQL_PASSWORD="$MYSQL_PASSWORD"
    -e MYSQL_DATABASE="$MYSQL_DATABASE"

    --rm
    -d
    )
