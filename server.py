import time
import zmq
import os
from datetime import datetime, timezone
import logging

os.environ["TZ"] = "America/Toronto"
time.tzset()
dt=datetime.now()
dt=dt.replace(tzinfo=timezone.utc)

fmt_str = "%(asctime)s - %(name)s - %(levelname)-8s - %(message)s"
fmt_date_str = "%d/%m/%Y %H:%M"
logging.basicConfig(filename=f'/logs/server-{datetime.today().strftime("%Y-%m-%d")}.log', format = fmt_str, datefmt = fmt_date_str,level=logging.INFO)
logging.info("{Start time: %s}",dt.isoformat())
context = zmq.Context()
socket = context.socket(zmq.REP)
socket.bind("tcp://*:5555")
time.sleep(10)

while True:
    #  Wait for next request from client
    message = socket.recv()
    logging.info("Received request: %s" % message)


    #  Do some 'work'
    time.sleep(3)

    #  Send reply back to client
    if "1" in str(message):
        socket.send(b"World1")
        logging.info("Received request: %s" % "World1")
    elif "2" in str(message):
        socket.send(b"World2")
        logging.info("Received request: %s" % "World2")
    else:
        socket.send(b"Message")
        logging.info("Received request: %s" % "Message")

logging.info("{End time: %s}",dt.isoformat())