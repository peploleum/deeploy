#!/bin/bash

# This script installs HDFS 2.5.0-2.6.0-cdh5.11.0 on DCOS 1.12
dcos package install --options=config.json hdfs
