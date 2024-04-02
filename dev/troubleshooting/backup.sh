if [ -z "$1" ]; then
    echo "No prefix provided, using default 'digma-docker'"
    prefix="digma-docker"
else
    prefix=$1
fi

# Run the container and perform backup for each volume
docker run --name backup_digma_volumes \
    -v ${prefix}_postgres_data_v1:/backup-postgres-data \
    -v ${prefix}_redis_data_v1:/backup-redis-data \
    -v ${prefix}_influxdb_data_v1:/backup-influxdb-data \
    -v ${prefix}_influxdb_config_v1:/backup-influxdb-config \
    busybox sh -c 'mkdir -p /backup && \
    tar -zcvf /backup/postgres_data.tar.gz -C /backup-postgres-data . && \
    tar -zcvf /backup/redis_data.tar.gz -C /backup-redis-data . && \
    tar -zcvf /backup/influxdb_data.tar.gz -C /backup-influxdb-data . && \
    tar -zcvf /backup/influxdb_config.tar.gz -C /backup-influxdb-config .'

# Move backup files to the desired directory
mkdir -p ./digma-volumes/

docker cp backup_digma_volumes:/backup/postgres_data.tar.gz ./digma-volumes/
docker cp backup_digma_volumes:/backup/redis_data.tar.gz ./digma-volumes/
docker cp backup_digma_volumes:/backup/influxdb_data.tar.gz ./digma-volumes/
docker cp backup_digma_volumes:/backup/influxdb_config.tar.gz ./digma-volumes/

# Remove the container
docker rm backup_digma_volumes