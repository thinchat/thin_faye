require 'redis'
load 'config/redis.rb'
load 'extensions/client.rb'
load 'extensions/faye_message.rb'

class ClientEvent
  MONITORED_CHANNELS = [ '/meta/subscribe', '/meta/disconnect' ]

  def incoming(message, callback)
    return callback.call(message) unless MONITORED_CHANNELS.include? message['channel']
    # puts message.inspect

    faye_message = FayeMessage.new(message)
    if client = get_client(faye_message)
      faye_client.publish(client.room, faye_message.build_hash(client))
    end
    callback.call(message)
  end

  def get_client(message)
    if message.action == 'subscribe'
      message.client.push
    elsif message.action == 'disconnect'
      message.client.pop
    end
  end

  def faye_client
    url = ENV["RACK_ENV"] == "production" ? "http://thinchat.com:9292" : "http://localhost:9292"
    @faye_client ||= Faye::Client.new("#{url}/faye")
  end
end