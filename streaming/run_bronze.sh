#!/bin/bash
set -e

python3 -m venv /tmp/streaming_venv
/tmp/streaming_venv/bin/python -m pip install --upgrade pip
/tmp/streaming_venv/bin/python -m pip install kafka-python

export PYSPARK_PYTHON=/tmp/streaming_venv/bin/python
export PYSPARK_DRIVER_PYTHON=/tmp/streaming_venv/bin/python

MASTER_IP=$(hostname -I | awk '{print $1}')
KAFKA_SERVER="${MASTER_IP}:9092"

spark-submit \
  --deploy-mode client \
  --packages io.delta:delta-spark_2.12:3.2.0 \
  --conf spark.pyspark.python=/tmp/streaming_venv/bin/python \
  --conf spark.pyspark.driver.python=/tmp/streaming_venv/bin/python \
  --conf spark.sql.extensions=io.delta.sql.DeltaSparkSessionExtension \
  --conf spark.sql.catalog.spark_catalog=org.apache.spark.sql.delta.catalog.DeltaCatalog \
  --conf spark.executor.memory=2g \
  --conf spark.driver.memory=1g \
  --conf spark.executor.cores=2 \
  --conf spark.yarn.maxAppAttempts=1 \
  s3://omniroute-gold/poc-bootcamp-group1-gold/streaming/bronze_telemetry_producer.py \
  --logical_date 2026-05-08 \
  --kafka_bootstrap "$KAFKA_SERVER" \
  --asset_history_path s3://omniroute-gold/poc-bootcamp-group1-gold/asset_history_scd2/ \
  --output_topic omniroute.telemetry.bronze \
  --refresh_interval_seconds 300 \
  --messages_per_vehicle 5 \
  --sleep_ms 5