if ENV['RAILS_ENV'] == 'development'
  REDIS_URL = 'localhost'
elsif ENV['RAILS_ENV'] == 'staging'
  REDIS_URL = 'http://50.116.40.131'
elsif ENV['RAILS_ENV'] == 'production'
  REDIS_URL = 'http://thinchat.com'
else
  raise NotImplementedError, "The environment '#{ENV["RAILS_ENV"]}' has no REDIS_URL\n Set one in config/initializers/redis.rb"
end