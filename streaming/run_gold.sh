#!/bin/bash

set -e

python3 -m pip install --user virtualenv
python3 -m virtualenv /mnt/tmp/streaming_venv

/mnt/tmp/streaming_venv/bin/python -m pip install --upgrade pip
/mnt/tmp/streaming_venv/bin/python -m pip install redis psycopg2-binary boto3

export PYSPARK_DRIVER_PYTHON=/mnt/tmp/streaming_venv/bin/python
unset PYSPARK_PYTHON

MASTER_IP=$(hostname -I | awk '{print $1}')
KAFKA_SERVER="${MASTER_IP}:9092"
REDIS_HOST="${MASTER_IP}"

spark-submit \
  --deploy-mode client \
  --packages org.apache.spark:spark-sql-kafka-0-10_2.12:3.5.1,io.delta:delta-spark_2.12:3.2.0,org.postgresql:postgresql:42.7.3 \
  --conf spark.pyspark.driver.python=/mnt/tmp/streaming_venv/bin/python \
  --conf spark.sql.extensions=io.delta.sql.DeltaSparkSessionExtension \
  --conf spark.sql.catalog.spark_catalog=org.apache.spark.sql.delta.catalog.DeltaCatalog \
  --conf spark.executor.instances=2 \
  --conf spark.executor.cores=2 \
  --conf spark.executor.memory=1g \
  --conf spark.driver.memory=1g \
  --conf spark.dynamicAllocation.enabled=false \
  --conf spark.yarn.maxAppAttempts=1 \
  s3://omniroute-gold/poc-bootcamp-group1-gold/streaming/gold_telemetry_violations_status.py \
  --kafka_bootstrap "$KAFKA_SERVER" \
  --input_topic omniroute.telemetry.silver \
  --restricted_zones_path s3://omniroute-bronze/poc-bootcamp-group1-bronze/static/restricted_zones.json \
  --driver_violation_events_path s3://omniroute-gold/poc-bootcamp-group1-gold/driver_violation_events/ \
  --driver_safety_status_path s3://omniroute-gold/poc-bootcamp-group1-gold/driver_safety_status/ \
  --checkpoint_path s3://omniroute-gold/poc-bootcamp-group1-gold/streaming/checkpoints/gold/ \
  --redis_host "$REDIS_HOST" \
  --redis_port 6379 \
  --pg_host "3.109.220.115" \
  --pg_port 5432 \
  --pg_database report \
  --pg_user postgres \
  --pg_password "postgres" \
  --pg_driver_events_table public.driver_safety_events \
  --pg_driver_safety_table public.driver_safety_status \
  --trigger_seconds 30