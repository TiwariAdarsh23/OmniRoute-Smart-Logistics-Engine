#!/bin/bash

set -e

MASTER_IP=$(hostname -I | awk '{print $1}')
KAFKA_SERVER="${MASTER_IP}:9092"

spark-submit \
  --deploy-mode client \
  --packages org.apache.spark:spark-sql-kafka-0-10_2.12:3.5.1 \
  --conf spark.executor.memory=2g \
  --conf spark.driver.memory=1g \
  --conf spark.executor.cores=2 \
  --conf spark.yarn.maxAppAttempts=1 \
  s3://omniroute-gold/poc-bootcamp-group1-gold/streaming/silver_telemetry_cleaner.py \
  --kafka_bootstrap "$KAFKA_SERVER" \
  --input_topic omniroute.telemetry.bronze \
  --output_topic omniroute.telemetry.silver \
  --checkpoint_path s3://omniroute-gold/poc-bootcamp-group1-gold/streaming/checkpoints/silver/ \
  --bad_path s3://omniroute-bronze/poc-bootcamp-group1-bronze/bad_data/telemetry_stream/ \
  --trigger_seconds 30