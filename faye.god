God.watch do |w|
  w.name = "faye"
  w.group = "faye_server"
  w.env = { 'RAILS_ENV' => "production" }
  w.dir = '/home/deployer/apps/thin_faye/current'
  w.start = "bundle exec ruby /home/deployer/apps/thin_faye/current/faye_server.rb -E production"
  w.keepalive
  w.log = "/var/log/faye/god_faye.log"
  w.err_log = "/var/log/faye/god_faye_error.log"
end
