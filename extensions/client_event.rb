load 'lib/client.rb'
load 'lib/faye_message.rb'
load 'config/initializers/root_url.rb'

class ClientEvent
  def incoming(message, callback)
    puts message.inspect

    faye_message = FayeMessage.new(message)
    # puts message.inspect if faye_message.interesting_message?
    return callback.call(message) unless faye_message.interesting_message?

    if add_or_remove_pulse(faye_message)
      # puts "THIS IS THE MESSAGE ---> #{faye_message.build_hash.to_json}"
      uri = URI.parse("#{ROOT_URL}/api/v1/messages")
      response = EventMachine::HttpRequest.new(uri).post :body => {:message => faye_message.build_hash.to_json}
    end
    callback.call(message)
  end

  def add_or_remove_pulse(message)
    if message.action == 'subscribe'
      PULSE.add(message.client)
    elsif message.action == 'disconnect'
      if client_hash = PULSE.delete(message.client)
        message.client = Client.new(client_hash)
      else
        puts "User's heartbeat not found. Original message: #{message.inspect}"
      end
    end
  end
end