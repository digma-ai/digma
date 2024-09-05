#!/bin/bash
namespace="$1"
presigned_url="$2"

echo $(date +'%H:%M:%S') starting postgres backup to s3
postgres_pod=$(kubectl get pods -n $namespace -l app=postgres -o jsonpath='{.items[0].metadata.name}')
kubectl exec -n $namespace $postgres_pod -- /bin/sh -c "
echo \$(date +'%H:%M:%S') backup started;
cd /;
backup_file='postgres-data.dump';
pg_dump -U postgres -d digma_analytics -F c -f \$backup_file;
apt upadte > /dev/null 2>&1;
apt install -y curl > /dev/null 2>&1;
file_size_bytes=\$(stat -c %s \$backup_file);  # Correct stat usage
# Calculate file size in MB using awk
file_size_mb=\$(echo \$file_size_bytes | awk '{printf \"%.2f\", \$1 / (1024 * 1024)}');
echo File size: \$file_size_mb MB;
echo \$(date +'%H:%M:%S') uploading file..;
curl -s '$presigned_url' | bash -s \$backup_file;
"
