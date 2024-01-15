# Scylla Benchmark

## Overview
Scylla Benchmark is a project designed to benchmark the performance of ScyllaDB instances. It includes Terraform scripts and configuration files to set up and monitor ScyllaDB instances on AWS.

## Features
- Automated deployment of ScyllaDB instances using Terraform.
- Monitoring setup for ScyllaDB performance.
- Pre-configured stress test profiles for benchmarking.

## Files Description
1. **Terraform Scripts**: 
   - [data.tf](https://github.com/ricardoborenstein/scylla-benchmark/blob/main/data.tf): Defines data sources for AWS availability zones, caller identity, and region.
   - [monitoring.tf](https://github.com/ricardoborenstein/scylla-benchmark/blob/main/monitoring.tf): Sets up an AWS instance for ScyllaDB monitoring.
   - [provider.tf](https://github.com/ricardoborenstein/scylla-benchmark/blob/main/provider.tf): Configures the AWS provider.
   - [scylla-instances.tf](https://github.com/ricardoborenstein/scylla-benchmark/blob/main/scylla-instances.tf): Defines the ScyllaDB instances.
   - [scylla_config.tf](https://github.com/ricardoborenstein/scylla-benchmark/blob/main/scylla_config.tf): Fetches existing ScyllaDB instances.
   - [scylladb-loaders.tf](https://github.com/ricardoborenstein/scylla-benchmark/blob/main/scylladb-loaders.tf): Configures loader instances for stress testing.
   - [security-group.tf](https://github.com/ricardoborenstein/scylla-benchmark/blob/main/security-group.tf): Configures AWS security groups for the instances.

2. **Service Configuration**:
   - [`cassandra-stress-benchmark.service`](https://github.com/ricardoborenstein/scylla-benchmark/blob/main/service/cassandra-stress-benchmark.service): Service file to start the Cassandra stress benchmark.
   - [`cassandra-stress.service`](https://github.com/ricardoborenstein/scylla-benchmark/blob/main/service/cassandra-stress.service): Service file to start Cassandra stress for populating ScyllaDB.
3. **Stress Test Profiles**:
- [stress-0.yml](https://github.com/ricardoborenstein/scylla-benchmark/blob/main/profile/stress-0.yml): Stress test profile configuration.
- [stress-1.yml](https://github.com/ricardoborenstein/scylla-benchmark/blob/main/profile/stress-1.yml): Alternative stress test profile.
- [stress-2.yml](https://github.com/ricardoborenstein/scylla-benchmark/blob/main/profile/stress-2.yml): Additional stress test profile for different scenarios.

## Prerequisites
- AWS account and AWS CLI configured.
- Terraform installed.
- Basic knowledge of ScyllaDB and Cassandra.

## Usage
1. Clone the repository.
2. Update the Terraform variables in `variables.tf` as per your AWS setup and requirements.
3. Initialize Terraform to download necessary plugins: `terraform init`.
4. Apply the Terraform scripts to create the infrastructure: `terraform apply`.
5. Monitor the performance of ScyllaDB instances using the provided monitoring setup.

## Customization
- Modify the stress test profiles in the `profile` directory to suit your benchmarking needs.
- Adjust the Terraform scripts for different AWS configurations or ScyllaDB versions.

## Contributing
Contributions to improve Scylla Benchmark are welcome. Please follow the standard procedures for submitting issues or pull requests.

## License
Please include information about the license under which this project is made available.
