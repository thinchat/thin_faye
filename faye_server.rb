require 'faye'

server = Faye::RackAdapter.new(:mount => '/faye', :timeout => 25)
bayeux.listen(9292)
