require '/home/deployer/apps/thin_faye/current/config/secret/campfire_token.rb'

God.watch do |w|
  w.name = 'faye_server'
  w.interval = 30.seconds
  w.env = { 'RAILS_ENV' => 'production' }
  w.uid = 'deployer'
  w.gid = 'admin'
  w.dir = '/home/deployer/apps/thin_faye/current'
  w.start = "bundle exec ruby faye_server.rb"
  w.start_grace = 10.seconds
  w.log = '/var/log/god/faye_server.log'

  # restart if memory gets too high
  w.transition(:up, :restart) do |on|
    on.condition(:memory_usage) do |c|
      c.above = 200.megabytes
      c.times = 2
      c.notify = 'faye_server'
    end
  end

  # determine the state on startup
  w.transition(:init, { true => :up, false => :start }) do |on|
    on.condition(:process_running) do |c|
      c.running = true
      c.notify = 'faye_server'
    end
  end

  # determine when process has finished starting
  w.transition([:start, :restart], :up) do |on|
    on.condition(:process_running) do |c|
      c.running = true
      c.interval = 5.seconds
      c.notify = 'faye_server'
    end

    # failsafe
    on.condition(:tries) do |c|
      c.times = 5
      c.transition = :start
      c.interval = 5.seconds
      c.notify = 'faye_server'
    end
  end

  # start if process is not running
  w.transition(:up, :start) do |on|
    on.condition(:process_running) do |c|
      c.running = false
      c.notify = 'faye_server'
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
  c.name = 'faye_server'
end
