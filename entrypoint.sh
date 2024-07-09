#!/bin/bash

# Start the VNC server
tightvncserver :1 -geometry 1280x800 -depth 24

# Source the ROS setup
source /opt/ros/melodic/setup.bash

# Activate the Python virtual environment
source /root/ros_ws/venv/bin/activate

# Ensure Python uses the correct version and environment
export PATH="/root/ros_ws/venv/bin:$PATH"

# Start the Python server script with the provided mode argument
python3 /root/ros_ws/server.py $1

