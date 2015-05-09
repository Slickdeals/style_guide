require 'serverspec'

set :backend, :exec
set :path, '/sbin:/usr/sbin:$PATH'

puts "OS Family: #{os[:family]} OS release: #{os[:release]}"
