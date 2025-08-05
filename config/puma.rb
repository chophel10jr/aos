app_dir = File.expand_path('..', __dir__)
shared_dir = "#{app_dir}/shared"

threads_count = ENV.fetch("RAILS_MAX_THREADS", 5).to_i
threads threads_count, threads_count

bind "unix://#{shared_dir}/sockets/puma.sock"

environment ENV.fetch("RAILS_ENV", "production")

pidfile "#{shared_dir}/pids/puma.pid"
state_path "#{shared_dir}/pids/puma.state"

stdout_redirect "#{shared_dir}/log/puma.stdout.log", "#{shared_dir}/log/puma.stderr.log", true

plugin :tmp_restart

