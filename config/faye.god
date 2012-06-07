require './campfire_token.rb'

God.watch do |w|
  w.name = "faye"
  w.group = "faye_server"
  w.env = { 'RAILS_ENV' => "production" }
  w.dir = '/home/deployer/apps/thin_faye/current'
  w.start = "bundle exec ruby /home/deployer/apps/thin_faye/current/faye_server.rb -E production"
  w.keepalive
  w.log = "/var/log/faye/god_faye.log"
  w.err_log = "/var/log/faye/god_faye_error.log"

  w.transition do |on|
    on.condition(:flapping) do |c|
      c.state  = [:start, :restart]
      c.times  = 1
      c.within = 1.minute
      c.notify = 'faye'
    end
  end
end

God::Contacts::Campfire.defaults do |d|
  d.subdomain = 'hungrymachine'
  d.token     = CAMPFIRE_TOKEN
  d.room      = 'HA Team 6'
  d.ssl       = true
end

God.contact(:campfire) do |c|
  c.name = 'faye'
end
