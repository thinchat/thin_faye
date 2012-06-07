require './campfire_token.rb'

God.watch do |w|
  w.name = "faye"
  w.interval      = 30.seconds
  w.start_grace   = 10.seconds
  w.group = "faye_server"
  w.env = { 'RAILS_ENV' => "production" }
  w.dir = '/home/deployer/apps/thin_faye/current'
  w.start = "bundle exec ruby /home/deployer/apps/thin_faye/current/faye_server.rb -E production"
  w.keepalive
  w.log = "/var/log/faye/god_faye.log"
  w.err_log = "/var/log/faye/god_faye_error.log"

  # restart if memory gets too high
  w.transition(:up, :restart) do |on|
    on.condition(:memory_usage) do |c|
      c.above = 200.megabytes
      c.times = 2
    end
  end

  # determine the state on startup
  w.transition(:init, { true => :up, false => :start }) do |on|
    on.condition(:process_running) do |c|
      c.running = true
    end
  end

  # determine when process has finished starting
  w.transition([:start, :restart], :up) do |on|
    on.condition(:process_running) do |c|
      c.running = true
      c.interval = 5.seconds
    end

    # failsafe
    on.condition(:tries) do |c|
      c.times = 5
      c.transition = :start
      c.interval = 5.seconds
    end
  end

  # start if process is not running
  w.transition(:up, :start) do |on|
    on.condition(:process_running) do |c|
      c.running = false
    end
  end

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
