from amqplib import client_0_8 as amqp
# Set up a connection and comms channel
conn = amqp.Connection(host="queue.eve-metrics.com:5672 ", userid="guest", password="guest", virtual_host="/", insist=False)
chan = conn.channel()
# Declare a queue and bind it to the order upload exchange
chan.queue_declare(queue="my_app_name", durable=False, exclusive=False, auto_delete=True)
chan.queue_bind(queue="my_app_name", exchange="market_order_uploads", routing_key="")
# Define a callback to receive the message
def recv_callback(msg):
  print "Received: " + msg.body
# Bind the consumer and callback
chan.basic_consume(queue="my_app_name", no_ack=True, callback=recv_callback, consumer_tag="testtag")
# Keep this thread open
while True:
  chan.wait()
chan.basic_cancel("testtag")

