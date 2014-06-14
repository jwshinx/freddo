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
  #before { DriveSession.delete_all }
  describe "GET on /drive_sessions" do
    before do 
      #DriveSession.create( name: 'HT001_gumby' )  
    end
    it "returns all drive sessions" do
      get "/drive_sessions"
      puts "---> s spec 1: #{File.dirname(__FILE__).to_s}"
      puts "---> s spec 2: #{$LOAD_PATH[0].to_s}"
      puts "---> s spec 3: #{DriveSession.first.name}"
      
      #last_response.should be_ok 
      #attributes = JSON.parse(last_response.body)
      #attributes.collect { |x| x['customer']['name'] }.include?( 'Mo' ).should be_true
      #attributes.collect { |x| x['customer']['name'] }.include?( 'Larry' ).should be_true
      #attributes.collect { |x| x['customer']['name'] }.include?( 'Curly' ).should be_true
      #attributes.collect { |x| x['customer']['name'] }.include?( 'Dave' ).should_not be_true
    end
  end
  
  #describe "PUT on /customers/:id" do
  #  it "should update a customer" do
  #    puts "---> s spec 1: #{File.dirname(__FILE__).to_s}"
  #    puts "---> s spec 2: #{$LOAD_PATH[0].to_s}"
  #    puts "---> s spec 3: #{:environment}"
  #    @c = Customer.create( name: 'Bob Dylan' ) 
  #    put "/customers/#{@c.id}", { name: 'Robert Dylan' }.to_json
  #    last_response.should be_ok
  #    get "/customers/#{Customer.find_by_name('Robert Dylan').id}"
  #    attributes = JSON.parse(last_response.body)['customer']
  #    attributes["name"].should == 'Robert Dylan'
  #  end
  #end
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