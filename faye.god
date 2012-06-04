God.watch do |w|
  w.name = "faye"
  w.start = "bundle exec ruby /home/deployer/apps/thin_faye/current/faye_server.rb -E production"
  w.keepalive
  w.log = "/var/log/faye/god_faye.log"
  w.error_log = "/var/log/faye/god_faye_error.log"
end
