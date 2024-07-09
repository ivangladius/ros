#!/bin/env python
import asyncio
import websockets
import json
import sys
from http.server import SimpleHTTPRequestHandler
from socketserver import TCPServer
import rospy
from geometry_msgs.msg import Twist
from frost_msgs.msg import PowertrainCommand
from threading import Thread

pub = None

# Function to handle incoming WebSocket connections
async def echo(websocket, path, mode):
    if mode == 'turtle':
        msg = Twist()
    elif mode == 'real':
        msg = PowertrainCommand()
    else:
        raise ValueError("Invalid mode. Use 'turtle' for simulation or 'real' for real mode.")

    async for message in websocket:
        data = json.loads(message)
        print(f"Received data: {data}")

        if mode == 'turtle':
            # Populate the Twist message with received data for turtlesim
            msg.linear.x = float(data['translationalSpeed'])
            msg.angular.z = float(data['rotationalSpeed'])
        elif mode == 'real':
            # Populate the PowertrainCommand message with received data for the real robot
            msg.mode = 1
            msg.enabled = int(data['motorsOn'])
            msg.trans_vel = float(data['translationalSpeed'])
            msg.rot_vel = float(data['rotationalSpeed'])

        # Publish the message to the ROS topic
        pub.publish(msg)

# Simple HTTP Server to serve static files
class HTTPServer(TCPServer):
    allow_reuse_address = True

def start_http_server():
    handler = SimpleHTTPRequestHandler
    httpd = HTTPServer(("0.0.0.0", 8000), handler)
    print("HTTP server is running at http://localhost:8000")
    httpd.serve_forever()

# Main function to initialize ROS node, start HTTP and WebSocket servers
async def main(mode):
    global pub

    # Initialize the ROS publisher based on the mode
    if mode == 'turtle':
        pub = rospy.Publisher('/turtle1/cmd_vel', Twist, queue_size=10)
    elif mode == 'real':
        pub = rospy.Publisher('chatter', PowertrainCommand, queue_size=10)

    rospy.init_node('turtle_controller', anonymous=True)

    # Start HTTP server in a new thread
    http_server_thread = Thread(target=start_http_server, daemon=True)
    http_server_thread.start()

    # Start WebSocket server and pass the mode to the echo function
    async with websockets.serve(lambda ws, path: echo(ws, path, mode), "0.0.0.0", 8765):
        await asyncio.Future()  # Run forever

if __name__ == "__main__":
    # Check command line arguments
    if len(sys.argv) != 2 or sys.argv[1] not in ['turtle', 'real']:
        print("Usage: python your_script.py [turtle|real]")
        sys.exit(1)

    mode = sys.argv[1]

    # Run the main function using asyncio and pass the mode
    asyncio.run(main(mode))
