require 'redis'
require 'thin_heartbeat'
load 'lib/client.rb'
load 'lib/faye_message.rb'

class HeartbeatEvent
  MONITORED_CHANNELS = [ '/heart_beat' ]

  def incoming(message, callback)
    return callback.call(message) unless MONITORED_CHANNELS.include? message['channel']
    ThinHeartbeat::Pulse.extend_life(message)
    callback.call(message)
  end
end