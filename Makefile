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
