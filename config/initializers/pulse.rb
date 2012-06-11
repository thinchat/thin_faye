if ENV['RAILS_ENV'] == 'production'
  require "./config/secret/redis_password.rb"
  PULSE = ThinHeartbeat::Pulse.new(REDIS_PASSWORD)
else
  PULSE = ThinHeartbeat::Pulse.new()
end