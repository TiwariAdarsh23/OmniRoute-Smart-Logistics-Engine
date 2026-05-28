# OmniRoute Smart Logistics Engine

A scalable logistics data platform built on AWS for processing fleet operations, driver activity, fuel transactions, and real-time telemetry data.

OmniRoute combines batch ETL pipelines with streaming analytics to deliver operational insights, safety monitoring, and automated reporting for large transportation fleets.

---

# Features

- Real-time vehicle telemetry processing
- Driver-to-vehicle historical tracking (SCD Type 2)
- Fuel efficiency anomaly detection
- Automated safety violation monitoring
- Monthly strike and deduction management
- Bronze → Silver → Gold medallion architecture
- Airflow-orchestrated data pipelines
- PostgreSQL reporting layer for BI tools

---

# Architecture

```text
Data Generators / Telemetry Streams
                │
                ▼
        ┌────────────────┐
        │   S3 Bronze    │
        │   Raw Layer    │
        └────────────────┘
                │
                ▼
        ┌────────────────┐
        │   S3 Silver    │
        │ Cleaned Layer  │
        └────────────────┘
                │
                ▼
        ┌────────────────┐
        │    S3 Gold     │
        │ Business Layer │
        └────────────────┘
                │
                ▼
        PostgreSQL Reporting
```

---

# Tech Stack

| Category | Technology |
|---|---|
| Cloud | AWS |
| Storage | Amazon S3 |
| Processing | Apache Spark / AWS Glue |
| Streaming | Spark Streaming / Kafka |
| Orchestration | Apache Airflow |
| Database | PostgreSQL |
| Query Engine | Amazon Athena |
| Language | Python |

---

# Core Modules

## Asset History Tracking

Tracks complete driver-to-vehicle assignment history using SCD Type 2 logic.

### Capabilities

- Active assignment management
- Historical record preservation
- Automatic archival of old assignments
- Conflict resolution handling

---

## Fuel Audit Engine

Detects abnormal fuel usage patterns using odometer and transaction analysis.

### Checks Performed

- Distance traveled between transactions
- Fuel efficiency calculation
- Baseline comparison
- Maintenance-day exclusions

---

## Driver Safety Monitoring

Processes telemetry events in real time to detect:

- Over-speeding
- Restricted zone violations
- Repeat offender patterns

Drivers accumulate strikes which impact compensation and suspension status.

---

# Data Layers

## Bronze Layer

Raw immutable storage for incoming datasets.

- CSV / JSON ingestion
- Partitioned storage
- Replay-safe architecture

---

## Silver Layer

Validated and cleaned datasets.

### Transformations

- Null removal
- VIN normalization
- Type casting
- Deduplication
- Timestamp validation

---

## Gold Layer

Business-ready analytical datasets.

### Main Tables

| Table | Description |
|---|---|
| `asset_history_scd2` | Historical driver assignments |
| `active_fleet_snapshot` | Active fleet metrics |
| `fuel_efficiency_audit` | Fuel anomaly reports |
| `driver_safety_status` | Driver compliance tracking |

---

# Project Structure

```bash
omniRoute/
│
├── generators/
├── glue_jobs/
│   ├── silver/
│   └── gold/
├── streaming/
├── dags/
├── reference/
├── state/
└── README.md
```

---

# Pipeline Flow

```text
Generate Raw Data
        ↓
Bronze Ingestion
        ↓
Silver Cleaning
        ↓
Gold Transformations
        ↓
Reporting Load
```

---

# Setup

## Install Dependencies

```bash
pip install pyspark boto3 apache-airflow
```

## Configure Airflow

```bash
cp dags/* $AIRFLOW_HOME/dags/
```

## Trigger Pipeline

```bash
airflow dags trigger daily_batch_dag
```

---

# Environment Variables

```bash
AWS_BUCKET_NAME=<bucket-name>
AWS_REGION=us-east-1

POSTGRES_HOST=<host>
POSTGRES_PORT=5432
POSTGRES_DB=postgres
POSTGRES_USER=postgres
POSTGRES_PASSWORD=<password>
```

---

# Future Improvements

- Predictive maintenance
- ML-based route optimization
- Real-time alerting dashboards
- Driver behavior scoring
- Fleet performance analytics

---

# License

MIT License