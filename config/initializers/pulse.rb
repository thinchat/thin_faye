require "./config/secret/redis_password.rb"
require "./config/intializers/redis.rb"

PULSE = ThinHeartbeat::Pulse.new(REDIS_URL, REDIS_PASSWORD)
