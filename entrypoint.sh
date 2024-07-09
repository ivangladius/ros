#!/bin/bash

# Start the VNC server
tightvncserver :1 -geometry 1280x800 -depth 24

# Source the ROS setup
source /opt/ros/melodic/setup.bash

# Activate the Python virtual environment
source /root/ros_ws/venv/bin/activate

# Start the Python server script with the provided mode argument
python /root/ros_ws/server.py $1

