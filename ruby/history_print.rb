require 'rubygems'
require 'amqp'
require 'mq'
AMQP.start(:host => 'queue.eve-metrics.com') do
  puts "Connected to AMQP server OK, listening for new messages"
  amq = MQ.new
  amq.queue('CHANGEME_APP_NAME_GOES_HERE', :exclusive=>true, :auto_delete=>true).bind(amq.fanout('market_history_uploads')).subscribe do |msg|
    puts msg
  end
end
