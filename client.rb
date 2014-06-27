require 'httparty'
require 'json'

base = 'http://localhost:4567'
puts "---> freddo client <------------------------------------------"

resp = HTTParty.get(base)
puts "\n---> '/'"
puts "code: #{resp.code.inspect}"
puts "message: #{resp.message.inspect}"
puts "body: #{resp.body.inspect}"

resp.headers.to_hash.each_pair do |k, v|
  puts "#{k.inspect} : #{v.inspect}"
end
#resp.headers.to_hash.each do |elem|
#  puts "#{JSON.pretty_generate(elem)}"
#end

resp = HTTParty.get(base + '/drive_sessions')
puts "\n---> '/drive-sessions'"
puts "code: #{resp.code.inspect}"
puts "message: #{resp.message.inspect}"
puts "body: #{resp.body.inspect}"

resp.headers.to_hash.each_pair do |k, v|
  puts "#{k.inspect} : #{v.inspect}"
end

