#!/bin/bash
namespace="$1"
SPLIT_SIZE_MB=100
curr_datetime=$(date +'%Y-%m-%d_%H-%M-%S')
local_folder=backups/$curr_datetime
mkdir -p $local_folder

echo "postgres backup to $local_folder"
dump_file_name='postgres-data.dump'
pod_backup_folder="backups/$curr_datetime"
pod_backup_file_path="$pod_backup_folder/$dump_file_name"
postgres_pod=$(kubectl get pods -n $namespace -l app=postgres -o jsonpath='{.items[0].metadata.name}')
kubectl exec -n $namespace -it $postgres_pod -- sh -c "mkdir -p $pod_backup_folder;pg_dump -U postgres -d digma_analytics -F c -f $pod_backup_file_path"

echo "Splitting remote file into parts of ${SPLIT_SIZE_MB}MB..."
# Run split command on the pod
kubectl exec -n "$namespace" "$postgres_pod" -- bash -c "split -b ${SPLIT_SIZE_MB}M $pod_backup_file_path ${pod_backup_file_path}_part_"

# Get a list of the split files
PART_FILES=$(kubectl exec -n "$namespace" "$postgres_pod" -- bash -c "ls ${pod_backup_file_path}_part_*")
if [ -z "$PART_FILES" ]; then
  echo "No split files found in pod. Something went wrong."
  exit 1
fi

# Create temporary directory to store file parts
TEMP_DIR=$(mktemp -d)
# Copy each part to the local machine
for PART_FILE in $PART_FILES; do
  echo "Copying $PART_FILE"
  file_name=$(basename "$PART_FILE")
  kubectl cp "$namespace/$postgres_pod:$PART_FILE" "$TEMP_DIR/$file_name"
  if [ $? -ne 0 ]; then


    echo "Failed to copy $PART_FILE. Exiting."
    exit 1
  fi
done

# Combine the parts into the original file
echo "Reassembling parts into $local_folder/$dump_file_name"
cat "$TEMP_DIR"/* > "$local_folder/$dump_file_name"
# Clean up temporary directory
rm -rf "$TEMP_DIR"
echo "File transfer complete!"

#kubectl cp -n $namespace $postgres_pod:/postgres-data.dump $folder/postgres-data.dump
