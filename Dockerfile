# Use the official ROS Melodic desktop full image
FROM osrf/ros:melodic-desktop-full-bionic

# Set environment variable to avoid user interaction
ENV DEBIAN_FRONTEND=noninteractive
ENV USER=root
ENV VNC_PASSWORD=gutenmorgenabend123

# Update the package list and install required dependencies
RUN apt-get update -y && \
    apt-get install -y \
    x11-apps tightvncserver xfce4 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Set up the environment for running graphical applications
ENV DISPLAY=:1
ENV QT_X11_NO_MITSHM=1

# Optional: Set up a workspace (customize as needed)
RUN mkdir -p /root/ros_ws/src
WORKDIR /root/ros_ws

# Source ROS setup.bash and build workspace (uncomment if you have a workspace)
# COPY . /root/ros_ws/
# RUN /bin/bash -c "source /opt/ros/melodic/setup.bash && catkin_make"

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

# Entry point to start VNC server
CMD ["bash", "-c", "tightvncserver :1 -geometry 1280x800 -depth 24 && bash"]

