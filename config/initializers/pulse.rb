if ENV['RAILS_ENV'] == 'production'
  require "#{Rails.root}/config/initializers/secret.rb"
  PULSE = ThinHeartbeat::Pulse.new(REDIS_PASSWORD)
else
  PULSE = ThinHeartbeat::Pulse.new()
end