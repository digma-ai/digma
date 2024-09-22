#!/bin/bash
namespace="$1"
presigned_url="$2"

echo $(date +'%H:%M:%S') connecting to pod..
postgres_pod=$(kubectl get pods -n $namespace -l app=postgres -o jsonpath='{.items[0].metadata.name}')
kubectl exec -n $namespace $postgres_pod -- /bin/sh -c "
query=\$(cat <<EOF
EXPLAIN ANALYZE SELECT 
                sp.span_classification  AS SpanClassification,
                sp.span_code_object_id  AS SpanCodeObjectId,
                sp.display_name AS DisplayName,
                sf.service AS Service,
                coi.insight_types AS Insight
            FROM spans sp                  
JOIN LATERAL (
SELECT DISTINCT service FROM span_flows
WHERE 
        account_id              = sp.account_id
    AND environment             = sp.environment
    AND span_code_object_id     = sp.span_code_object_id
    AND updated_time         > now() - INTERVAL '14 day'
) AS sf ON TRUE
            JOIN LATERAL (
                SELECT DISTINCT string_agg(insight_type, ',' ORDER BY insight_type) as insight_types FROM (
                        SELECT 
                            DISTINCT insight_type 
                        FROM code_object_insights
                        WHERE 
                            account_id              = sp.account_id
                        AND environment             = sp.environment
                        AND code_object_id  = sp.span_code_object_id
                            AND is_active               = true
                            AND NOT (insight_type       = ANY (array['SpanDurations', 'SpanDurationBreakdown', 'SpanUsages']))
             AND is_dismissed                = false
                    UNION 
                        SELECT 
                            DISTINCT insight_type
                        FROM span_descendants AS sd 
                            JOIN code_object_insights AS coi    ON 
                                    coi.code_object_id  = sd.descendant_span_code_object_id
                                AND coi.account_id              = sd.account_id
                                AND coi.environment             = sd.environment                                  
                        WHERE 
                                sd.account_id             = sp.account_id
                            AND sd.environment            = sp.environment
                            AND sd.span_code_object_id    = sp.span_code_object_id
                            AND coi.is_active                   = true   
                            AND NOT (coi.insight_type           = ANY (array['SpanDurations', 'SpanDurationBreakdown', 'SpanUsages']))
             AND is_dismissed                = false
                ) AS joined ) AS coi ON TRUE
            WHERE 
                    sp.account_id               = '00000000-0000-0000-0000-000000000000'
                AND sp.environment              = 'SOME_ENV'
                AND coi.insight_types           IS NOT NULL
                AND sp.latest_span_timestamp    > now() - INTERVAL '14 day'
                AND sp.span_role = 'Entry';
EOF
);
apt update -qq;
apt install -y curl;

cd /;
file='query_result.txt';
psql -U postgres -d digma_analytics -c \"\$query\" > \$file;
echo \$(date +'%H:%M:%S') uploading result..;
echo ''
echo \"$presigned_url\"
echo ''
curl -X PUT -T \"\$file\" \"$presigned_url\" > /dev/null;
"
