require "./config/secret/redis_password.rb"
require "./config/intiialiers/redis.rb"

PULSE = ThinHeartbeat::Pulse.new(REDIS_URL, REDIS_PASSWORD)
