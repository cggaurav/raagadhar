require 'sinatra'
require 'mongo'

if ENV['MONGOHQ_URL']
	uri = URI.parse(ENV['MONGOHQ_URL'])
	conn = Mongo::Connection.from_uri(ENV['MONGOHQ_URL'])
	db = conn.db(uri.path.gsub(/^\//, ''))
else
  	db = Mongo::Connection.new('localhost').db('raagadhar')
end

raagas = db.collection('raagas')
definitions = db.collection('definitions')
dictionary = db.collection('dictionary')

get '/' do
	@raagas = raagas
	puts @raagas.inspect
	erb :index
end

get '/define/:raaga' do
	@raaga = params[:raaga]
	puts @raaga
	erb :define
end


get '/raaga/:raaga' do 
	raaga = params[:raaga].downcase


	erb :raaga
end


get '/submit' do
	
end