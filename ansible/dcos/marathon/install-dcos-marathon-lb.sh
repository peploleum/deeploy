#!/bin/bash

# This script installs marathon lb 2.8.0-2.4.0 on DCOS 1.12
dcos package install --options=marathon-lb-config.json  marathon-lb
