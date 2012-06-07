God.watch do |w|
  w.name = 'faye_server'
  w.env = { 'RAILS_ENV' => 'production' }
  w.uid = 'deployer'
  w.gid = 'deployer'
  w.dir = '/home/deployer/apps/thin_faye/current'
  w.start = "bundle exec ruby faye_server.rb"
  w.start_grace = 10.seconds
  w.log = '/var/log/god/faye_server.log'

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
end
