load 'lib/client.rb'
load 'lib/faye_message.rb'

class ClientEvent
  MONITORED_CHANNELS = [ '/meta/subscribe', '/meta/disconnect' ]

  def incoming(message, callback)
    puts message.inspect
    return callback.call(message) unless MONITORED_CHANNELS.include? message['channel']

    faye_message = FayeMessage.new(message)
    if client = get_client(faye_message)
      [ client.room, '/online_users' ].uniq.each do |channel|
        faye_client.publish(channel, faye_message.build_hash(client))
      end
    end
    callback.call(message)
  end

  def get_client(message)
    if message.action == 'subscribe'
      PULSE.add(message.client)
    elsif message.action == 'disconnect'
      client_hash = PULSE.delete(message.client)
      Client.new(client_hash)
    end
  end

  def faye_client
    url = ENV["RACK_ENV"] == "production" ? "http://thinchat.com:9292" : "http://localhost:9292"
    @faye_client ||= Faye::Client.new("#{url}/faye")
  end
end