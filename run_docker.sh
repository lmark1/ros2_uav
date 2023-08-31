#!/bin/bash


XSOCK=/tmp/.X11-unix
XAUTH=/tmp/.docker.xauth
touch $XAUTH
xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -

# Hook to the current SSH_AUTH_LOCK - since it changes
# https://www.talkingquickly.co.uk/2021/01/tmux-ssh-agent-forwarding-vs-code/
ln -sf $SSH_AUTH_SOCK ~/.ssh/ssh_auth_sock

docker run \
  -it \
  --network host \
  --privileged \
  --gpus all \
  --volume=$XSOCK:$XSOCK:rw \
  --volume=$XAUTH:$XAUTH:rw \
  --volume ~/.ssh/ssh_auth_sock:/ssh-agent \
  --env SSH_AUTH_SOCK=/ssh-agent \
  --env="XAUTHORITY=${XAUTH}" \
  --env DISPLAY=$DISPLAY \
  --env TERM=xterm-256color \
  --name uav_ros_simulation_ros2 \
  ros2:focal \
  /bin/bash
