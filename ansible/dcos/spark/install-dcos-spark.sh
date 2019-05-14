#!/bin/bash

# This script installs spark 2.8.0-2.4.0 on DCOS 1.12
dcos package install --options=config.json  spark
