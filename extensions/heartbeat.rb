require 'redis'
load 'extensions/client.rb'
load 'extensions/faye_message.rb'

class Heartbeat
  MONITORED_CHANNELS = [ '/heart_beat' ]

  def incoming(message, callback)
    return callback.call(message) unless MONITORED_CHANNELS.include? message['channel']
    # puts message.inspect
    Client.extend_life(message)
    callback.call(message)
  end
end