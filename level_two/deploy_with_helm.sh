#!/bin/bash

# Install Tree.
$ sudo apt install tree

# Create context directory and display Tree structure.
$ EXPORT BUILD_DIR && tree $BUILD_DIR

# Update dependencies for the chart.
$ helm dependency update


