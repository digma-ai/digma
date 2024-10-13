#!/bin/bash
namespace="$1"

echo $(date +'%H:%M:%S') connecting to pod..
postgres_pod=$(kubectl get pods -n $namespace -l app=postgres -o jsonpath='{.items[0].metadata.name}')
kubectl exec -n $namespace $postgres_pod -- /bin/sh -c "
query=\$(cat <<EOF
\copy (select Environment, SpanCodeObjectId, SpanDisplayName, STRING_AGG(SamplesCount::TEXT, ', ') as Samples
            from (
            select  h.environment as Environment , h.span_code_object_id as SpanCodeObjectId, s.display_name as SpanDisplayName , h.window_time_hourly as Time, sum(h.bin_value) as SamplesCount
            from spans s
            inner join span_duration_hourly_histogram h on h.account_id =s.account_id and h.environment = s.environment and h.span_code_object_id = s.span_code_object_id
            where s.span_role ='Entry'
            group by h.account_id , h.environment , h.span_code_object_id ,  s.display_name,  h.window_time_hourly
            order by h.account_id , h.environment , s.display_name, h.window_time_hourly
            ) as t
            group by Environment, SpanCodeObjectId, SpanDisplayName) TO STDOUT WITH CSV HEADER
EOF
);
cd /;

file='query_result.csv';
psql -U postgres -d digma_analytics -c \"\$query\" > \$file;
";

curr_datetime=$(date +'%Y-%m-%d_%H-%M-%S')
folder=results/$curr_datetime
mkdir -p $folder
kubectl cp -n $namespace $postgres_pod:/query_result.csv $folder/entries_samples_count.csv
