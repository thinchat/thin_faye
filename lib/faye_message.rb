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
                                         'location'  => "#{client.location}",
                                         'message_body' => action_message } }
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

  # def user_name
  #   message.data.user_name if message.data
  # end

  # def user_id
  #   message.data.user_id if message.data
  # end

  # def user_type
  #   message.data.user_type if message.data
  # end

  # def location
  #   message.data.location if message.data
  # end

  [:user_name, :user_id, :user_type, :location].each do |name|
    define_method name do
      message.data.send(name) if message.data
    end
  end

  def channel
    message.subscription
  end

end