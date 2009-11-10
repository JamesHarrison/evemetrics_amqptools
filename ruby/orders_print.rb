# Require amqp library
require 'rubygems'
require 'amqp'
require 'mq'
# Handle signals for clean shutdown on ctrl+c
Signal.trap('INT') { AMQP.stop{ EM.stop } }
Signal.trap('TERM'){ AMQP.stop{ EM.stop } }
# Start connection
AMQP.start(:host => 'queue.eve-metrics.com') do
  puts "Connected to AMQP server OK, listening for new messages"
  amq = MQ.new
  # Define queue and bind it to the fanout exchange for market order uploads
  amq.queue('CHANGEME_APP_NAME_GOES_HERE', :exclusive=>true, :auto_delete=>true).bind(amq.fanout('market_order_uploads')).subscribe do |msg|
    puts msg
  end
end
