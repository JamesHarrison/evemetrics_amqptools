import java.io.IOException;
import com.rabbitmq.client.*;

public class PrintMessages {
	public static void main( String[] args ) {
		String queueName = "my_queue_name";
		String exchangeName = "market_order_uploads";
		ConnectionParameters params = new ConnectionParameters();
		params.setUsername( "guest" );
		params.setPassword( "guest" );
		params.setVirtualHost( "/" );
		params.setRequestedHeartbeat( 0 );
		ConnectionFactory factory = new ConnectionFactory( params );
		Connection conn;
		Channel channel;
		try {
			conn = factory.newConnection( "queue.eve-metrics.com", 5672 );
			channel = conn.createChannel();
			// Declare a queue, not passive, not durable, exclusive, autodelete
			channel.queueDeclare( queueName, false, false, true, true, null );
			channel.queueBind( queueName, exchangeName, "*" );
			boolean noAck = false;
			QueueingConsumer consumer = new QueueingConsumer( channel );
			channel.basicConsume( queueName, noAck, consumer );
			while (true) {
				QueueingConsumer.Delivery delivery;
				try {
					delivery = consumer.nextDelivery();
					channel.basicAck( delivery.getEnvelope().getDeliveryTag(), false );
					String msg = new String( delivery.getBody(), "UTF8" );
					System.out.println( "Received message: \n" + msg );
				} catch (InterruptedException ie) {
					System.out.println( "Got interrupt, exiting" );
					channel.close();
					conn.close();
				}
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}

