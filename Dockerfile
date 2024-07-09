# Use the official ROS Melodic desktop full image
FROM osrf/ros:melodic-desktop-full-bionic

# Set environment variable to avoid user interaction
ENV DEBIAN_FRONTEND=noninteractive
ENV USER=root
ENV VNC_PASSWORD=gutenmorgenabend123

# Update the package list and install required dependencies
RUN apt-get update -y && \
    apt-get install -y \
    x11-apps tightvncserver xfce4 python3-venv python3-pip && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Set up the environment for running graphical applications
ENV DISPLAY=:1
ENV QT_X11_NO_MITSHM=1

# Optional: Set up a workspace (customize as needed)
RUN mkdir -p /root/ros_ws/src
WORKDIR /root/ros_ws

# Copy the entire project directory
COPY . /root/ros_ws/

# Source ROS setup.bash every time a new shell is started
RUN echo "source /opt/ros/melodic/setup.bash" >> /root/.bashrc

# Set up VNC server and set the password
RUN mkdir -p /root/.vnc && \
    echo "xfce4-session &" > /root/.vnc/xstartup && \
    echo $VNC_PASSWORD | vncpasswd -f > /root/.vnc/passwd && \
    chmod 600 /root/.vnc/passwd && \
    echo "export ROS_MASTER_URI=http://localhost:11311" >> /root/.bashrc && \
    echo "export ROS_HOSTNAME=localhost" >> /root/.bashrc

# Expose the VNC port
EXPOSE 5901

# Create and activate a Python virtual environment, install requirements
RUN python3 -m venv /root/ros_ws/venv && \
    /root/ros_ws/venv/bin/pip install -r /root/ros_ws/requirements.txt

# Copy the entrypoint script
COPY entrypoint.sh /root/ros_ws/

# Make the entrypoint script executable
RUN chmod +x /root/ros_ws/entrypoint.sh

# Entry point to start VNC server and the server script
CMD ["/root/ros_ws/entrypoint.sh"]

