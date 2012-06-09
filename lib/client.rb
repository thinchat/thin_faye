require 'json'
require 'active_support/core_ext'

class Client
  CLIENT_ATTRIBUTES = [:user_name, :user_id, :user_type, :room_id, :client_id, :room]
  attr_reader *CLIENT_ATTRIBUTES

  def initialize(hash)
    CLIENT_ATTRIBUTES.each do |attr|
      instance_variable_set("@#{attr}", hash[attr] || hash[attr.to_s])
    end
  end

  def self.new_from_message(message)
    Client.new({ "user_id" => message.user_id,
                 "user_name" => message.user_name,
                 "user_type" => message.user_type,
                 "room" => message.room,
                 "room_id" => message.room_id,
                 "client_id" => message.client_id })
  end
end
