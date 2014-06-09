require 'sinatra'
require 'active_record'
require 'yaml'
require 'haml'

env_index = ARGV.index("-e")
env_arg = ARGV[env_index + 1] if env_index
env = env_arg || ENV["SINATRA_ENV"] || "development"
databases = YAML.load_file("config/database.yml")
ActiveRecord::Base.establish_connection(databases[env])

$LOAD_PATH << File.expand_path('../models', __FILE__)
require 'drive_session'

if env == 'test'
  puts "---> starting in test mode"
  puts "---> 1: #{env_index.inspect}"
  puts "---> 2: #{env_arg.inspect}"
  puts "---> 3: #{env.inspect}"
  puts "---> 4: #{ENV["SINATRA_ENV"].inspect}"

  #Customer.destroy_all
  #puts "customers: all destroyed"
  #Customer.create( name: 'Barack' )
  #puts "initializing: barack"
  #puts "customer: #{Customer.all.inspect}"
elsif env == 'development'
  puts "---> starting in development mode"
  puts "---> 1: #{env_index.inspect}"
  puts "---> 2: #{env_arg.inspect}"
  puts "---> 3: #{env.inspect}"
  puts "---> 4: #{ENV["SINATRA_ENV"].inspect}"  
end

get '/' do
  'Hello Oakland!!!!'
end

get '/drive_sessions/first' do
  ds = DriveSession.first
  if ds
    ds.to_json
  else
    error 404, { error: 'drive session nonexistent' }.to_json
  end
  #JSON.pretty_generate(
  haml :first, :layout => :drive_session, :locals => { :ds => ds }
end

get '/drive_sessions/new' do
  #puts "---> request: #{request.inspect}"
  #puts "---> body: #{request.body.inspect}"
  haml :new, :layout => :drive_session
end

post '/drive_sessions' do
  ds = DriveSession.find_by_name('HT001_joelshin')
  if ds
    puts "---> ht001_joelshin exists: #{@ds.inspect}"
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

=begin
get '/customers/:id' do
  cust = Customer.find_by_id params[:id]
  if cust
    cust.to_json
  else
    error 404, { error: 'customer not found' }.to_json
  end
end

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
=end
