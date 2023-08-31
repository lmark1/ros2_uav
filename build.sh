#!/bin/bash

# Build tomas image first
# docker build -t tomas:focal -f Dockerfile.tomas .

# Start building ROS2
docker build -t ros2:focal -f Dockerfile.uav .

