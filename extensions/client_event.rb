load 'lib/client.rb'
load 'lib/faye_message.rb'
load 'config/initializers/root_url.rb'

class ClientEvent
  MONITORED_CHANNELS = [ '/meta/subscribe', '/meta/disconnect' ]

  def incoming(message, callback)
    return callback.call(message) unless MONITORED_CHANNELS.include? message['channel']
    puts message.inspect

    faye_message = FayeMessage.new(message)
    if add_or_remove_pulse(faye_message)
      uri = URI.parse("#{ROOT_URL}/api/v1/messages")
      response = EventMachine::HttpRequest.new(uri).post :body => {:message => faye_message.build_hash.to_json}
      
      # [ client.channel, '/online_users' ].uniq.each do |channel|
      #   faye_client.publish(channel, faye_message.build_hash(client))
      # end
    end
    callback.call(message)
  end

  def add_or_remove_pulse(message)
    if message.action == 'subscribe'
      PULSE.add(message.client)
    elsif message.action == 'disconnect'
      client_hash = PULSE.delete(message.client)
      message.client = Client.new(client_hash)
    end
  end

  def faye_client
    url = ENV["RACK_ENV"] == "production" ? "http://thinchat.com:9292" : "http://localhost:9292"
    @faye_client ||= Faye::Client.new("#{url}/faye")
  end
end