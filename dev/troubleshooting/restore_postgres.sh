if [ -z "$1" ]; then
    echo "Missing dump file"
    echo "restore_postgress.sh <dump-file>"
    exit 1
else
    dump_file=$1
fi

persistence_container=$(docker ps --filter "name=digma-persistence" --format "{{.Names}}")

echo "Copying dump into volume"
docker cp $dump_file $persistence_container:/etc/lib/postgresql/data-pg/dump

echo "Retoring dump"
docker exec -it $persistence_container sh -c 'pg_restore -c -U postgres -F c -d digma_analytics /etc/lib/postgresql/data-pg/dump'
