require 'rubygems'
require 'yaml'
require 'amqp'
require 'mq'
# Trap signals for clean shutdown
Signal.trap('INT') { AMQP.stop{ EM.stop } }
Signal.trap('TERM'){ AMQP.stop{ EM.stop } }
AMQP.start(:host => 'queue.eve-metrics.com') do
  puts "Connected to AMQP server OK, listening for new messages"
  amq = MQ.new
  # Declares the queue and binds it to the exchange
  amq.queue('CHANGEME_APP_NAME_GOES_HERE', :exclusive=>true, :auto_delete=>true).bind(amq.fanout('market_order_uploads')).subscribe do |msg|
    upload = YAML::load(msg) # Parse the YAML message
    # Print a notification
    puts "Got new message uploaded at #{upload[:received_at]} by UID #{upload[:user_id]}/DKID #{upload[:developer_key_id]}"
    # Write to uploads/upload_<timeinseconds>.txt
    File.open("uploads/upload_#{upload[:received_at].to_i}.txt", "w"){|f| f << upload[:body] }
  end
end

