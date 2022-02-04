#!/bin/bash

set -e

trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
trap 'echo "$0: \"${last_command}\" command failed with exit code $?"' ERR

echo "$0: Building ros1_bridge"

ROS_BRIDGE_WS_PATH=/root/ros2_bridge_workspace
CATKIN_WS=/root/uav_ws

# create ros2_workspace
[ ! -e $ROS_BRIDGE_WS_PATH/src ] && mkdir -p $ROS_BRIDGE_WS_PATH/src

cd $ROS_BRIDGE_WS_PATH/src
[ ! -e ros1_bridge ] && git clone https://github.com/ros2/ros1_bridge
cd ros1_bridge
git fetch
git checkout galactic

cd $ROS_BRIDGE_WS_PATH
source /opt/ros/galactic/setup.bash
source $CATKIN_WS/devel/setup.bash
colcon build --symlink-install --packages-select ros1_bridge --cmake-force-configure