#!/bin/bash

if [ -z "$1" ]; then
    echo "Missing project name"
    echo "restore_postgres_as_compound.sh <docker compose project> <dump-file>"
    exit 1
else
    project=$1
fi

if [ -z "$2" ]; then
    echo "Missing dump file"
    echo "restore_postgres_as_compound.sh <docker compose project> <dump-file>"
    exit 1
else
    dump_file=$2
fi

persistence_container=$(docker ps --filter "name=$project-digma-persistence" --format "{{.Names}}")
if [ -z "$persistence_container" ]; then
    echo "Container was not found"
    exit 1
fi

echo "Copying dump into $persistence_container"
docker cp $dump_file $persistence_container:/dump

echo "Retoring dump"
docker exec -it $persistence_container sh -c 'pg_restore -c -U postgres -F c -d digma_analytics /dump'
