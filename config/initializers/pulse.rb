if ENV['RAILS_ENV'] == 'production'
  REDIS_URL = 'http://thinchat.com'
elsif ENV['RAILS_ENV'] == 'staging'
  REDIS_URL = 'http://50.116.40.131'
else
  REDIS_URL = 'localhost'
end

PASSWORD_REQUIRED = ['production', 'staging']

if PASSWORD_REQUIRED.include? ENV['RAILS_ENV']
  require "./config/secret/redis_password.rb"
  PULSE = ThinHeartbeat::Pulse.new(REDIS_URL, REDIS_PASSWORD)
else
  PULSE = ThinHeartbeat::Pulse.new(REDIS_URL)
end