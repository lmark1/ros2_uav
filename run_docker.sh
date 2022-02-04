#!/bin/bash


XSOCK=/tmp/.X11-unix
XAUTH=/tmp/.docker.xauth
touch $XAUTH
xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -

docker run \
  --rm \
  -it \
  --network host \
  --privileged \
  --gpus all \
  --volume=$XSOCK:$XSOCK:rw \
  --volume=$XAUTH:$XAUTH:rw \
  --env="XAUTHORITY=${XAUTH}" \
  --env DISPLAY=$DISPLAY \
  --env TERM=xterm-256color \
  --name uav_ros_simulation_ros2 \
  uav_ros_simulation:ros2 \
  /bin/bash
