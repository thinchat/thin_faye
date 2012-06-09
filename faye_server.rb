require 'faye'
require 'hashie'
require 'eventmachine'
require 'redis'
load 'extensions/client_event.rb'
load 'extensions/heartbeat_event.rb'
load 'extensions/stop_reconnect.rb'

Faye::WebSocket.load_adapter('thin')
server = Faye::RackAdapter.new(:mount => '/faye', :timeout => 25)
server.add_extension(ClientEvent.new)
server.add_extension(HeartbeatEvent.new)
# server.add_extension(StopReconnect.new)

server.bind(:handshake) do |client_id|
  server.get_client.publish('/faye_server', {
    'text' => "Handshake - client_id:#{client_id}"
  })
end

server.bind(:subscribe) do |client_id, channel|
  server.get_client.publish('/faye_server', {
    'text' => "Subscribe - client_id:#{client_id} channel:#{channel}"
  })
end

server.bind(:unsubscribe) do |client_id, channel|
  server.get_client.publish('/faye_server', {
    'text' => "Unsubscribe - client_id:#{client_id} channel:#{channel}"
  })
end

server.bind(:publish) do |client_id, channel, data|
  server.get_client.publish('/faye_server', {
    'text' => "Publish - client_id:#{client_id} channel:#{channel} data:#{data}"
  }) unless channel == '/faye_server'
end

server.bind(:disconnect) do |client_id|
  server.get_client.publish('/faye_server', {
    'text' => "Disconnect - client_id:#{client_id}"
  })
end

server.listen(9292)