workers Integer(ENV['WEB_CONCURRENCY'] || 3)
threads_count = Integer(ENV['THREAD_COUNT'] || 2)
threads threads_count, threads_count

rackup      DefaultRackup
port        ENV['HTTP_PORT'] || 8888
environment ENV['JETS_ENV']  || 'development'
