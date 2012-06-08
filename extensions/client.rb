require 'json'
require 'active_support/core_ext'

class Client
  attr_reader :user_name, :user_id, :user_type, :room_id, :client_id, :room

  def initialize(hash)
    @user_id = hash["user_id"]
    @user_name = hash["user_name"]
    @user_type = hash["user_type"]
    @room = hash["room"]
    @room_id = hash["room_id"]
    @client_id = hash["client_id"]
  end

  def self.new_from_message(message)
    Client.new({ "user_id" => message.user_id,
                 "user_name" => message.user_name,
                 "user_type" => message.user_type,
                 "room" => message.room,
                 "room_id" => message.room_id,
                 "client_id" => message.client_id })
  end

  def self.extend_life(heartbeat)
    key = get_key_from_heartbeat(heartbeat)
    REDIS.expire key, 30
  end

  def self.get_key_from_heartbeat(heartbeat)
    hb = Hashie::Mash.new(heartbeat)
    "hb:#{hb.data.user_type}:#{hb.data.user_id}:#{hb.clientId}:#{hb.data.room_id}"
  end

  def get_key
    raise self.inspect if user_id.blank? || user_type.blank?
    "hb:#{user_type}:#{user_id}:#{client_id}:#{room_id}"
  end

  def push
    REDIS.sadd get_key, self.to_json
    REDIS.expire get_key, 30
    self
  end

  def pop
    key = REDIS.keys "hb:*:#{client_id}:*"
    # puts "KEY: #{key.first.inspect}"
    client_json = REDIS.spop key.first
    # puts "CLIENT_JSON: #{client_json.inspect}"
    Client.new(JSON.parse(client_json))
  end
end
