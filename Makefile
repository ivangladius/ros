build:
	docker build -t ros-melodic-vnc .

run:
	docker run -it --rm --net=host ros-melodic-vnc

shell:
	docker run -it --rm --net=host ros-melodic-vnc /bin/bash

roscore:
	docker run -it --rm --net=host ros-melodic-vnc bash -c "tightvncserver :1 -geometry 1280x800 -depth 24 && roscore"

turtlesim:
	docker run -it --rm --net=host ros-melodic-vnc bash -c "tightvncserver :1 -geometry 1280x800 -depth 24 && roscore & sleep 5 && rosrun turtlesim turtlesim_node"

server-turtle:
	docker run --rm --net=host ros-melodic-vnc bash -c "tightvncserver :1 -geometry 1280x800 -depth 24 && /root/ros_ws/venv/bin/python3 /root/ros_ws/server.py turtle"

server-real:
	docker run --rm --net=host ros-melodic-vnc bash -c "tightvncserver :1 -geometry 1280x800 -depth 24 && /root/ros_ws/venv/bin/python3 /root/ros_ws/server.py real"

http-server:
	docker run --rm --net=host ros-melodic-vnc bash -c "tightvncserver :1 -geometry 1280x800 -depth 24 && python3 -m http.server 8000 --directory /root/ros_ws/"

