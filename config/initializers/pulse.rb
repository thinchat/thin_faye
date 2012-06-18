require "./config/initializers/redis.rb"
PULSE = ThinHeartbeat::Pulse.new($redis)
