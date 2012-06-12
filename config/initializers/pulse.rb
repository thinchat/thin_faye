require "./config/secret/redis_password.rb"
PULSE = ThinHeartbeat::Pulse.new(REDIS_PASSWORD)
