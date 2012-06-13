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

  def build_hash
    message_hash = { 'message_type' => action.capitalize,
                     'user_id'   => "#{client.user_id}", 
                     'user_type' => "#{client.user_type}",
                     'user_name' => "#{client.user_name}",
                     'client_id' => "#{client.client_id}",
                     'location'  => "#{client.location}",
                     'channel'   => "#{client.channel}",
                     'body' => action_message }
  end

  def action_message
    if action == 'subscribe'
      "#{client.user_name} entered."
    elsif action == 'disconnect'
      "#{client.user_name} left."
    end
  end

  def client_id
    message.clientId
  end

  [:user_name, :user_id, :user_type, :location].each do |name|
    define_method name do
      message.data.send(name) if message.data
    end
  end

  def channel
    message.subscription
  end

end