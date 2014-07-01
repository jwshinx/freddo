require 'spec_helper'

#require File.dirname(__FILE__) + '/../lib' 
#$LOAD_PATH << File.expand_path('../models', __FILE__)
#require 'customer'
#require 'spec'
#require 'spec/interop/test'
#require 'rack/test'

#set :environment, :test
#Test::Unit::TestCase.send :include, Rack::Test::Methods

#def app
# Sinatra::Application
#end

puts "---> Environment: #{settings.environment}"
puts "---> Environment: #{settings.class.methods.grep(/attr/).inspect}"

#settings.each { |s| puts "---> s: #{s.inspect}"}

describe "services" do
  before { DriveSession.delete_all }
  describe "GET on /drive_sessions" do
    before do 
      @salt = ('a'..'z').to_a.shuffle[0,10].join
      DriveSession.create( name: 'HT001_gumby_' + @salt, last_updated: Time.now, rig_id: 'HT001' )  
    end
    it "returns all drive sessions" do
      get "/drive_sessions"
      #puts "---> s spec 1: #{File.dirname(__FILE__).to_s}"
      #puts "---> s spec 2: #{$LOAD_PATH[0].to_s}"
      #puts "---> s spec 3: #{DriveSession.first.name}"
      #DriveSession.all.each { |ds| puts "---> #{ds.name}"}
      #puts "---> attrs lr: #{last_response.inspect}"
      expect(last_response).to be_ok
      attributes = JSON.parse(last_response.body)
      attributes.each do |x| 
        expect( x['name'].include?( 'HT001_gumby_' + @salt) ).to be true
        expect( x['rig_id'] ).to eq('HT001')
      end
    end
  end
  describe "GET on /drive_sessions/first" do
    before do 
      @salt = ('a'..'z').to_a.shuffle[0,10].join
      DriveSession.create( name: 'HT001_gumby_' + @salt, last_updated: Time.now, rig_id: 'HT001' )  
    end
    it "returns one drive session" do
      get "/drive_sessions/first"
      expect(last_response).to be_ok
      attributes = JSON.parse(last_response.body)
      expect( attributes['name']).to eq( 'HT001_gumby_' + @salt)
    end
  end

  describe "GET on /drive_sessions/:name" do
    before do 
      @salt = ('a'..'z').to_a.shuffle[0,10].join
      DriveSession.create( name: 'HT001_gumby_' + @salt, last_updated: Time.now, rig_id: 'HT001' )  
    end    
    it "returns drive session" do
      get "/drive_sessions/HT001_gumby_#{@salt}"
      expect(last_response).to be_ok
      attributes = JSON.parse(last_response.body)
      expect( attributes['name']).to eq( 'HT001_gumby_' + @salt)
    end
    it "should return a 404 for a drive session that doesn't exist" do
      get "/drive_sessions/HT001_gumby_uuuuuuuuuu"
      expect(last_response.status).to eq(404)
      attributes = JSON.parse(last_response.body)
      expect(attributes['error']).to eq("drive session nonexistent")
    end
  end

  describe "PUT on /drive_sessions/:name" do
    before do 
      @salt = ('a'..'z').to_a.shuffle[0,10].join
      DriveSession.create( name: 'HT001_gumby_' + @salt, last_updated: Time.now, rig_id: 'HT001' )  
    end        
    it "should update server-version" do
      put "/drive_sessions/HT001_gumby_#{@salt}", {
        :server_version => "atari 2600"}.to_json
      expect(last_response).to be_ok
      get "/drive_sessions/HT001_gumby_#{@salt}"
      attributes = JSON.parse(last_response.body)
      expect(attributes['server_version']).to eq("atari 2600")
    end    
    it "should return a 404 for a drive session that doesn't exist" do
      put "/drive_sessions/HT001_gumby_#{@salt}", {
        :server_version => "atari 2600"}.to_json
      get "/drive_sessions/HT001_gumby_junkjunk"
      expect(last_response.status).to eq(404)
      attributes = JSON.parse(last_response.body)
      expect(attributes['error']).to eq("drive session nonexistent")

      #expect(last_response).to be_ok
      #get "/drive_sessions/HT001_gumby_#{@salt}"
      #attributes = JSON.parse(last_response.body)
      #expect(attributes['server_version']).to eq("atari 2600")
    end    
  end
=begin
describe "PUT on /api/v1/users/:id" do
    it "should update a user" do
      User.create(
        :name => "bryan",
        :email => "no spam",
        :password => "whatever",
        :bio => "rspec master")
      put '/api/v1/users/bryan', {
        :bio => "testing freak"}.to_json
      last_response.should be_ok
      get '/api/v1/users/bryan'
      attributes = JSON.parse(last_response.body)["user"]
      attributes["bio"].should == "testing freak"
    end
  end
=end
end

=begin
describe "services" do
 before { Customer.delete_all }
 
 describe "PUT on /customers/:id" do
  it "should update a customer" do
    puts "---> s spec 1: #{File.dirname(__FILE__).to_s}"
    puts "---> s spec 2: #{$LOAD_PATH[0].to_s}"
    puts "---> s spec 3: #{:environment}"
   @c = Customer.create( name: 'Bob Dylan' ) 
   put "/customers/#{@c.id}", { name: 'Robert Dylan' }.to_json
   last_response.should be_ok
   get "/customers/#{Customer.find_by_name('Robert Dylan').id}"
   attributes = JSON.parse(last_response.body)['customer']
   attributes["name"].should == 'Robert Dylan'
  end
 end
  
 describe "DELETE on /customers/:id" do
  it "should delete a customer" do
   @c = Customer.create( name: 'Pee Wee' ) 
   delete "/customers/#{@c.id}"
   last_response.should be_ok
   get "/customers/#{@c.id}"
   last_response.status.should == 404 
   attributes = JSON.parse(last_response.body)
   attributes['error'].should == 'customer not found'
  end
 end

 describe "POST on /customers" do
  it "should create a new customer" do
   post '/customers', {
    name: 'Mark Twain'
   }.to_json
   last_response.should be_ok
   get "/customers/#{Customer.find_by_name('Mark Twain').id}"
   attributes = JSON.parse(last_response.body)['customer']
   attributes["name"].should == 'Mark Twain'
  end
 end

 describe "GET on /customers" do
  before do 
   Customer.create( name: 'Curly' ) 
   Customer.create( name: 'Mo' ) 
   Customer.create( name: 'Larry' ) 
  end
  it "returns all customers" do
   get "/customers"
   last_response.should be_ok 
   attributes = JSON.parse(last_response.body)
   attributes.collect { |x| x['customer']['name'] }.include?( 'Mo' ).should be_true
   attributes.collect { |x| x['customer']['name'] }.include?( 'Larry' ).should be_true
   attributes.collect { |x| x['customer']['name'] }.include?( 'Curly' ).should be_true
   attributes.collect { |x| x['customer']['name'] }.include?( 'Dave' ).should_not be_true
  end
 end

 describe "GET on /customers/:id" do
  before { @c = Customer.create( name: 'Bob Dylan' ) }
  it "returns customer by :id" do
   get "/customers/#{@c.id}"
   last_response.should be_ok 
   attributes = JSON.parse(last_response.body)['customer']
   attributes["name"].should == 'Bob Dylan'
  end
  it "returns 404 when customer doesn't exist" do
   get "/customers/98884"
   last_response.status.should == 404
  end
 end
end

describe "at root" do
 describe "GET on /" do
  it "should return *Hello Oakland*" do
   get '/'
   last_response.should be_ok
   last_response.body.should match(/Hello Oakland!!!!/)
   last_response.status.should == 200 
   #attributes = JSON.parse(last_response.body)
   #attributes["name"].should == 'joel'
  end
 end
end
=end