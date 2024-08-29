#!/bin/bash

if [ -z "$1" ]; then
    echo "No project provided"
    echo "restore_docker.sh <docker-compose-project-name> <backup-folder>"
    project=$1
fi

if [ -z "$2" ]; then
    echo "No backup folder prefix provided"
    echo "restore_docker.sh <docker-compose-project-name> <backup-folder>"
    exit 1
fi

project=$1
folder=$(realpath "$PWD/$2")

persistence_container=$(docker ps --filter "name=$project-digma-persistence" --format "{{.Names}}")
if [ -z "$persistence_container" ]; then
    echo "Container was not found"
    exit 1
fi

echo "Stopping $persistence_container"
docker stop $persistence_container

echo "Copying data to $persistence_container"
docker run --rm --name backup_digma_volumes \
    -v ${project}_postgres_data_v1:/backup-postgres-data \
    -v ${project}_redis_data_v1:/backup-redis-data \
    -v ${project}_influxdb_data_v1:/backup-influxdb-data \
    -v ${project}_influxdb_config_v1:/backup-influxdb-config \
    -v "$folder":/backups \
    busybox sh -c ' \
    cp /backups/postgres_data.dump /backup-postgres-data
    tar -xzf /backups/redis_data.tar.gz -C /backup-redis-data && \
    tar -xzf /backups/influxdb_data.tar.gz -C /backup-influxdb-data && \
    tar -xzf /backups/influxdb_config.tar.gz -C /backup-influxdb-config'

echo "Starting again $persistence_container"
docker start $persistence_container

docker exec -it $persistence_container sh -c 'until pg_isready -U postgres; do sleep 1; done; \
    pg_restore -c -U postgres -F c -d digma_analytics /etc/lib/postgresql/data-pg/postgres_data.dump'

echo "Successfully restored backups"
