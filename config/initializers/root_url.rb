if ENV['RAILS_ENV'] == 'production'
  ROOT_URL = 'http://thinchat.com'
elsif ENV['RAILS_ENV'] == 'staging'
  ROOT_URL = 'http://50.116.40.131'
else
  ROOT_URL = 'http://localhost:3000'
end