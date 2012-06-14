require 'faye'
require 'hashie'
require 'eventmachine'
require 'redis'
load 'extensions/client_event.rb'
load 'extensions/heartbeat_event.rb'
load 'extensions/stop_reconnect.rb'
load 'config/initializers/pulse.rb'

Faye::WebSocket.load_adapter('thin')
server = Faye::RackAdapter.new(:mount => '/faye', :timeout => 25)

server.add_extension(StopReconnect.new) unless ENV['RAILS_ENV'] == 'production'
server.add_extension(ClientEvent.new)
server.add_extension(HeartbeatEvent.new)

server.listen(9292)