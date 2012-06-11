require 'hashie'

class FayeMessage
  attr_accessor :message, :client

  def initialize(message)
    @message = Hashie::Mash.new(message)
  end

  def action
    message.channel.split('/').last if message.channel
  end

  def client
    @client ||= Client.new_from_message(self)
  end

  def build_hash(client=nil)
    message_hash = { 'chat_message' => { 'message_type' => action.capitalize,
                                         'user_name' => "#{client.user_name}",
                                         'client_id' => "#{client.client_id}",
                                         'room_id' => "#{client.room_id}" } }
    if action == 'subscribe'
      message_hash['chat_message']['message_body'] = "#{client.user_name} entered."
    elsif action == 'disconnect'
      message_hash['chat_message']['message_body'] ="#{client.user_name} left."
    end
    message_hash
  end

  def client_id
    message.clientId
  end

  def user_name
    message.data.user_name if message.data
  end

  def user_id
    message.data.user_id if message.data
  end

  def user_type
    message.data.user_type if message.data
  end

  def room
    message.subscription
  end

  def room_id
    message.data.room_id if message.data
  end
end