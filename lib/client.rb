require 'json'
require 'active_support/core_ext'

class Client
  CLIENT_ATTRIBUTES = [:user_name, :user_id, :user_type, :location, :client_id, :channel]
  attr_reader *CLIENT_ATTRIBUTES

  def initialize(hash)
    CLIENT_ATTRIBUTES.each do |attr|
      instance_variable_set("@#{attr}", hash[attr] || hash[attr.to_s])
    end
  end

  def self.new_from_message(faye_message)
    Client.new({ "user_id"   => faye_message.user_id,
                 "user_name" => faye_message.user_name,
                 "user_type" => faye_message.user_type,
                 "channel"   => faye_message.channel,
                 "location"  => faye_message.location,
                 "client_id" => faye_message.client_id })
  end
end
