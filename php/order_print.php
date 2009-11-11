#!/usr/bin/env php
<?php
/**
 * 
 *  Most of the code was ripped from the php-amqplib's consumer demo
 *
 */

require_once('./php-amqp/amqp.inc');


declare(ticks = 1);


$EXCHANGE = 'market_order_uploads';

$QUEUE = 'php_test_queue';
$CONSUMER_TAG = 'MY_APP_NAME_GOES_HERE';

function sig_handler($signo)
{
  if($signo == SIGINT)
  {
    echo "Exiting ...";
    $GLOBALS['ch']->close();
    $GLOBALS['conn']->close();
    exit;
  }
}


pcntl_signal(SIGINT,  "sig_handler");

$conn = new AMQPConnection('queue.eve-metrics.com', 5672, 'guest', 'guest');
$ch = $conn->channel();
$ch->access_request('/', false, false, true, true);

$ch->queue_declare($QUEUE);
$ch->exchange_declare($EXCHANGE, 'fanout', false, false, false);
$ch->queue_bind($QUEUE, $EXCHANGE);

function process_message($msg) {
    global $ch, $CONSUMER_TAG;

    echo "\n--------\n";
    echo $msg->body;
    echo "\n--------\n";
}

$ch->basic_consume($QUEUE, $CONSUMER_TAG, false, false, false, false, 'process_message');

// Loop as long as the channel has callbacks registered
while(count($ch->callbacks)) {
    $ch->wait();
}


?>
