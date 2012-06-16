require "./config/initializers/redis.rb"

PULSE = ThinHeartbeat::Pulse.new(REDIS_URL)
