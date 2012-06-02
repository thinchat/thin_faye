require 'faye'

Faye::WebSocket.load_adapter('thin')
server = Faye::RackAdapter.new(:mount => '/faye', :timeout => 25)
server.listen(9292)
