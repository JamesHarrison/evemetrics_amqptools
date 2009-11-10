# Java Tools

The Java example clients use the [RabbitMQ Java Client](http://www.rabbitmq.com/java-client.html "RabbitMQ Website") which must be downloaded and installed to run the example clients.

If you just download the binaries, you can build and run the example client with the following commands:

    javac -extdirs /path/to/rabbitmq-java-client-bin-1.7.0 PrintMessages.java
    /path/to/rabbitmq-java-client-bin-1.7.0/runjava.sh PrintMessages

This will automatically include the correct jars.
