require 'sinatra'
require 'active_record'
require 'yaml'
require 'haml'
require './sinatra/post_get'

env_index = ARGV.index("-e")
env_arg = ARGV[env_index + 1] if env_index
puts "---> 1: #{env_index.inspect}"
puts "---> 2: #{env_arg.inspect}"

env = env_arg || ENV["SINATRA_ENV"] || "development"
databases = YAML.load_file("config/database.yml")
ActiveRecord::Base.establish_connection(databases[env])
puts "---> 3: #{env.inspect}"
puts "---> 4: #{ENV["SINATRA_ENV"].inspect}"  
puts "---> 5: #{databases[env].inspect}"
#settings.methods.each { |x| puts "---> settings m: #{x.inspect}" }


$LOAD_PATH << File.expand_path('../models', __FILE__)
require 'drive_session'

if env == 'test'
  puts "---> starting in test mode. env is test"

  #Customer.destroy_all
  #puts "customers: all destroyed"
  #Customer.create( name: 'Barack' )
  #puts "initializing: barack"
  #puts "customer: #{Customer.all.inspect}"
elsif env == 'development'
  puts "---> starting in development mode. env is dev"
end

before do
  @author = 'joel'
  content_type :txt
end

get '/' do
  "hello\n"
end

post_get '/postget' do
  # post: curl -v --data "param1=value1&param2=value2" http://localhost:4567/postget
  "hi #{@joel}, im postget\n#{params.inspect}\n\n"
end

get '/drive_sessions/first' do
  ds = DriveSession.first
  if ds
    ds.to_json
  else
    error 404, { error: 'drive session nonexistent' }.to_json
  end
  #JSON.pretty_generate(
  #haml :first, :layout => :drive_session, :locals => { :ds => ds }
end

get '/drive_sessions/:name' do
  #puts "---> in the service: #{params.inspect}"
  ds = DriveSession.find_by_name(params['name'])
  if ds
    ds.to_json
  else
    error 404, { error: 'drive session nonexistent' }.to_json
  end
  #JSON.pretty_generate(
  #haml :first, :layout => :drive_session, :locals => { :ds => ds }
end

put '/drive_sessions/:name' do
  #puts "---> update 1: #{request.body.inspect}"
  #puts "---> update 2: #{request.inspect}"
  ds = DriveSession.find_by_name(params['name'])
  if ds
    begin
      attributes = JSON.parse(request.body.read)
      updated_ds = ds.update(attributes)
      if updated_ds
        ds.to_json
      else
        error 400, ds.errors.to_json
      end
    rescue => e
      error 400, {:error => e.message}.to_json
    end
  else
    error 404, {:error => 'drive session not found'}.to_json
  end
end

get '/drive_sessions/new' do
  #puts "---> request: #{request.inspect}"
  #puts "---> body: #{request.body.inspect}"
  haml :new, :layout => :drive_session
end

post '/xpostx' do
  name = params['name']
end

post '/drive_sessions' do
  ds = DriveSession.find('HT001_joelshin')
  if ds
    ds.to_json
  else
    begin
      now = Time.now
      ds = DriveSession.create( name: 'HT001_joelshin', last_updated: now, rig_id: "HT001", du_id: '666', 
        server_version: '1.1.1', capture_count: '444', start_time: now, end_time: now, 
        current_event: 'STEPOFF' )
      if ds.valid?
        ds.to_json
      else
        error 400, ds.errors.to_json
      end
    rescue => e
      error 400, e.message.to_json
    end
  end
end

get '/drive_sessions' do
  drive_sessions = DriveSession.all
  if drive_sessions.empty?
    error 404, { :error => 'drive sessions not found' }.to_json
  else
    drive_sessions.to_json
  end
end

#get '/*' do
#  puts "---> sldfsdf #{params.inspect}"
#  "you entered some rrrroute #{params['splat'].inspect}\n\n\n\n"
#end

get '/halt' do
  "not visible\n\n\n"
  halt 500  
end

get %r{/(sp|gr)eedy} do
  text = "author: #{@author}\n#{request.path.inspect}\n"
  request.env.each { |e| text << e.to_s + "\n"}
  text << "\n\n\n"
  request.methods.each { |e| text << e.to_s + "\n"}
  text << "\n\n\n"
  text
end

get '/myhtml' do
  content_type :html
  '<h3>my html</h3>'
end

get '/xcv' do
  headers "X-Custom-Value" => 'oaklandddddddddddd'
  "set custom-value\n\n\n"
end

get '/mxcv' do
  headers "X-Custom-Value" => 'red', "X-Custom-Value-2" => 'blue'
  "set multi-custom-value\n\n\n"
end

#not_found do
#  "Joel says: 'That is shit. Not found.'\n\n\n"
#end

after do
  ActiveRecord::Base.clear_active_connections!
end

=begin

post '/customers' do
  begin
    customer = Customer.create(JSON.parse(request.body.read))
    if customer.valid?
     customer.to_json
    else
     error 400, customer.errors.to_json
    end
  rescue => e
    error 400, e.message.to_json
  end
end

put '/customers/:id' do
  begin
    customer = Customer.find_by_id params[:id]
    if customer
      begin
        if customer.update_attributes(JSON.parse(request.body.read))
          customer.to_json
        else
          error 400, customer.errors.to_json
        end
      rescue => e
        error 400, e.message.to_json
      end
    else
      error 404, { :error => 'customer not found' }.to_json
    end
  end
end

delete '/customers/:id' do
  customer = Customer.find_by_id params[:id]
  if customer
    customer.destroy
    customer.to_json
  else
    error 404, { :error => 'customer not found' }.to_json
  end
end

__END__

@@speedy
<!DOCTYPE html>
<html>
<body>

<span>speedy rendered</span>

</body>
</html>
=end
