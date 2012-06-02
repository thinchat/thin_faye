God.watch do |w|
  w.name = "faye"
  w.start = "ruby /home/deployer/apps/thin_faye/current/faye_server.rb"
  w.keepalive
end
