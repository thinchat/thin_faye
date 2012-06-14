require "./config/secret/redis_password.rb"
require "./config/initializers/redis.rb"

PULSE = ThinHeartbeat::Pulse.new(REDIS_URL)
