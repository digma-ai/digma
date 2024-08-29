#!/bin/bash

if [ -z "$1" ]; then
    echo "No project provided, using default 'digma-docker'"
    project="digma-docker"
else
    project=$1
fi

persistence_container=$(docker ps --filter "name=$project-digma-persistence" --format "{{.Names}}")
if [ -z "$persistence_container" ]; then
    echo "Container was not found"
    exit 1
fi

curr_datetime=$(date +'%Y-%m-%d_%H-%M-%S')
folder=$(realpath "$PWD/backups/$curr_datetime") 
mkdir -p $folder

docker exec -it $persistence_container sh -c 'pg_dump -U postgres -d digma_analytics -F c -f /etc/lib/postgresql/data-pg/dump'

# Run the container and perform backup for each volume
docker run --rm --name backup_digma_volumes \
    -v ${project}_postgres_data_v1:/backup-postgres-data \
    -v ${project}_redis_data_v1:/backup-redis-data \
    -v ${project}_influxdb_data_v1:/backup-influxdb-data \
    -v ${project}_influxdb_config_v1:/backup-influxdb-config \
    -v "$folder":/backups \
    busybox sh -c ' \
    cp /backup-postgres-data/dump /backups/postgres_data.dump && \
    tar -zcvf /backups/redis_data.tar.gz -C /backup-redis-data . && \
    tar -zcvf /backups/influxdb_data.tar.gz -C /backup-influxdb-data . && \
    tar -zcvf /backups/influxdb_config.tar.gz -C /backup-influxdb-config .'

echo "Successfully backup to $folder"