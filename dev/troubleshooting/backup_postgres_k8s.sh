#!/bin/bash
namespace="$1"
presigned_url="$2"
SPLIT_SIZE_MB=50
curr_datetime=$(date +'%Y-%m-%d_%H-%M-%S')
local_folder=backups/$curr_datetime
mkdir -p $local_folder

echo $(date +'%H:%M:%S') Postgres backup to $local_folder
dump_file_name='postgres-data.dump'
pod_backup_folder="backups/$curr_datetime"

pod_backup_file_path="$pod_backup_folder/$dump_file_name"
postgres_pod=$(kubectl get pods -n $namespace -l app=postgres -o jsonpath='{.items[0].metadata.name}')

kubectl exec -n $namespace -it $postgres_pod -- sh -c "mkdir -p $pod_backup_folder;pg_dump -U postgres -d digma_analytics -F c -f $pod_backup_file_path"
kubectl exec -n $namespace $postgres_pod -- /bin/sh -c "
cd /;
file_size_bytes=\$(stat -c %s $pod_backup_file_path);  # Correct stat usage
# Calculate file size in MB using awk
file_size_mb=\$(echo \$file_size_bytes | awk '{printf \"%.2f\", \$1 / (1024 * 1024)}');
echo \$(date +'%H:%M:%S') Backup File size: \$file_size_mb MB;
"

echo $(date +'%H:%M:%S') Splitting remote file into parts of ${SPLIT_SIZE_MB}MB...
# Run split command on the pod
kubectl exec -n "$namespace" "$postgres_pod" -- bash -c "split -b ${SPLIT_SIZE_MB}M $pod_backup_file_path ${pod_backup_file_path}_part_"

# Get a list of the split files
PART_FILES=$(kubectl exec -n "$namespace" "$postgres_pod" -- bash -c "ls ${pod_backup_file_path}_part_*")
if [ -z "$PART_FILES" ]; then
  echo $(date +'%H:%M:%S') No split files found in pod. Something went wrong.
  exit 1
fi
echo $(date +'%H:%M:%S') Done

total_files=$(echo $PART_FILES | wc -w)
total_files="${total_files// /}"
counter=0
# Create temporary directory to store file parts
TEMP_DIR=$(mktemp -d)

# Copy each part to the local machine
for PART_FILE in $PART_FILES; do
  counter=$((counter + 1))
  # Print the progress
  echo ''
  echo "$(date +'%H:%M:%S') Copying $PART_FILE ($counter of $total_files)"

  file_name=$(basename "$PART_FILE")
  kubectl exec -n $namespace $postgres_pod -- dd if=$PART_FILE bs=1M | dd of=$TEMP_DIR/$file_name

  if [ $? -ne 0 ]; then
    echo $(date +'%H:%M:%S') Failed to copy $PART_FILE. Exiting.
    exit 1
  fi
done

# Combine the parts into the original file
echo ''
echo $(date +'%H:%M:%S') Reassembling parts into $local_folder/$dump_file_name
cat "$TEMP_DIR"/* > "$local_folder/$dump_file_name"
# Clean up temporary directory
rm -rf "$TEMP_DIR"
echo $(date +'%H:%M:%S') File transfer complete!
echo ''
echo "Calculating checksum on the pod..."
remote_checksum=$(kubectl exec -n $namespace $postgres_pod -- cksum "$pod_backup_file_path" | awk '{print $1}')
echo "Calculating checksum on the local machine..."
local_checksum=$(cksum "$local_folder/$dump_file_name" | awk '{print $1}')

# Compare checksums
if [ "$REMOTE_CHECKSUM" == "$LOCAL_CHECKSUM" ]; then
    echo "File copy verified successfully: checksums match."
    echo ''
    echo File location: $local_folder/$dump_file_name
else
    echo "File copy verification failed: checksums do not match."
    echo "Remote checksum: $remote_checksum"
    echo "Local checksum: $local_checksum"
    exit 1
fi

if [[ -n "$presigned_url" ]]; then
    echo $(date +'%H:%M:%S') uploading file to s3..;
    curl -X PUT -T $local_folder/$dump_file_name '$presigned_url'> /dev/null
fi