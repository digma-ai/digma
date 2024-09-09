#!/bin/bash


if [ -z "$1" ]; then
    echo "Missing project name"
    echo "restore_postgres_as_distributed.sh <docker compose project> <dump-file>"
    exit 1
else
    project=$1
fi

if [ -z "$2" ]; then
    echo "Missing dump file"
    echo "restore_postgres_as_distributed.sh <docker compose project> <dump-file>"
    exit 1
else
    dump_file=$2
fi

postgres_container=$(docker ps --filter "name=$project-postgres" --format "{{.Names}}")
if [ -z "$postgres_container" ]; then
    echo "Container was not found. Run /deploy/dev/runservicesonly.sh"
    exit 1
fi

echo "Copying dump into $persistence_container"
docker cp $dump_file $postgres_container:/dump

echo "Retoring dump"
docker exec -it $postgres_container sh -c "psql -U postgres -c \"SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = 'digma_analytics';\""
docker exec -it $postgres_container sh -c 'dropdb -U postgres digma_analytics'
docker exec -it $postgres_container sh -c 'createdb -U postgres digma_analytics'
docker exec -it $postgres_container sh -c 'pg_restore -U postgres -F c -d digma_analytics /dump'
