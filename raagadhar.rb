require 'sinatra'
require 'mongo'
require 'nokogiri'
require 'open-uri'
require 'json'

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
	erb :index
end

get '/define/:raaga' do
	@raaga = params[:raaga]
	erb :define
end


get '/raaga' do 
	raaga = params[:raaga].downcase
	puts raaga
	url = "http://index.bonsai.io/7bfy61vro8h8nothcjzz/test/_search/?q=name:#{raaga}"
	@raaga_json = JSON.parse(Nokogiri::HTML(open(url)))["hits"]["hits"]
	puts @raaga_json
	erb :raaga
end


get '/submit' do
	
end