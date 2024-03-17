import zmq
import os
from datetime import datetime, timezone
import logging

os.environ["TZ"] = "America/Toronto"
dt=datetime.now()
dt=dt.replace(tzinfo=timezone.utc)

context = zmq.Context()
#logging.basicConfig(filename='HISTORYlistener.log',level=logging.DEBUG,format='%(asctime)s.%(msecs)03d %(levelname)s %(module)s - %(funcName)s: %(message)s',datefmt='%Y-%m-%d %H:%M:%S')

fmt_str = "%(asctime)s - %(name)s - %(levelname)-8s - %(message)s"
fmt_date_str = "%d/%m/%Y %H:%M"
logging.basicConfig(filename=f'/logs/client2-{datetime.today().strftime("%Y-%m-%d")}.log', format = fmt_str, datefmt = fmt_date_str,level=logging.INFO)

logging.info("{Start time: %s}",dt.isoformat())

#  Socket to talk to server
logging.error("Connecting to hello world server…")
socket = context.socket(zmq.REQ)
socket.connect("tcp://server:5555")

#  Do 10 requests, waiting each time for a response
for request in range(500):
    logging.info("Sending request %s message: %s", request,"Hello2")
    socket.send(b"Hello2")
    #  Get the reply.
    message = socket.recv()
    logging.info("Received reply %s [ %s ]" % (request, message))

logging.info("{End time: %s}",dt.isoformat())