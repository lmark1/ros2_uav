#!/bin/bash

set -e

trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
trap 'echo "$0: \"${last_command}\" command failed with exit code $?"' ERR

echo "$0: Building ros1_bridge"

ROS_BRIDGE_WS_PATH=/root/ros2_bridge_workspace
CATKIN_WS=/root/uav_ws

# create ros2_workspace
[ ! -e $ROS_BRIDGE_WS_PATH/src ] && mkdir -p $ROS_BRIDGE_WS_PATH/src

clone_ros1_bridge() {
  cd $ROS_BRIDGE_WS_PATH/src
  [ ! -e ros1_bridge ] && git clone https://github.com/ros2/ros1_bridge
  cd ros1_bridge
  git fetch
  git checkout galactic
}

clone_message_repos() {
  cd $ROS_BRIDGE_WS_PATH/src
  [ ! -e mavros ] && git clone https://github.com/mavlink/mavros.git
  cd mavros
  git fetch
  git checkout ros2

  [ ! -e geographic_info ] && git clone https://github.com/ros-geographic-info/geographic_info.git
  cd geographic_info
  git fetch
  git checkout ros2
}

build_message_repos() {
  cd $ROS_BRIDGE_WS_PATH
  source /opt/ros/galactic/setup.bash
  colcon build --symlink-install --packages-select geographic_msgs
  colcon build --symlink-install --packages-select mavros_msgs
}

build_ros1_bridge() {
  cd $ROS_BRIDGE_WS_PATH
  source $CATKIN_WS/devel/setup.bash
  source $ROS_BRIDGE_WS_PATH/install/setup.bash
  colcon build --symlink-install --packages-select ros1_bridge --cmake-force-configure
}

clone_ros1_bridge
clone_message_repos
build_message_repos
build_ros1_bridge