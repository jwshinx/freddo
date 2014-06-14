#require 'factory_girl'
$LOAD_PATH << File.expand_path('../../lib', __FILE__)
#$LOAD_PATH.each { |x| puts "---> LP: #{x.inspect}"}

require 'drive_session'
require File.join(File.dirname(__FILE__), '..', 'service.rb')
require 'sinatra'
require 'rack/test'

set :environment, :test
set :run, false
set :raise_errors, true
set :logging, false

def app
  Sinatra::Application
end

RSpec.configure do |config|
  config.include Rack::Test::Methods
end

puts "---> lets reassert test connection start"
databases = YAML.load_file("config/database.yml")
ActiveRecord::Base.establish_connection(databases['test'])
puts "---> lets reassert test connection end"


#FactoryGirl.find_definitions