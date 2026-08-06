# End-to-End Banking Data Warehouse using dbt, Snowflake & Apache Airflow

## 📌 Project Overview

This project implements an end-to-end banking data warehouse pipeline using **Snowflake**, **dbt**, and **Apache Airflow**.

The main goal is to transform raw banking transaction data into a structured analytical data warehouse following a **Star Schema** design.

The pipeline includes:
- Loading raw transaction data into Snowflake.
- Building a staging layer using dbt for data cleaning and transformation.
- Implementing data quality tests using dbt tests.
- Tracking customer changes using dbt Snapshots (SCD Type 2).
- Creating dimension and fact tables for analytics.
- Orchestrating the complete workflow using Apache Airflow.

The final warehouse provides a reliable and organized structure for analyzing banking transactions, customer information, merchants, payment methods, and transaction attributes.