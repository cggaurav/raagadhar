require 'sinatra'
require 'mongo'

if ENV['MONGOHQ_URL']
	uri = URI.parse(ENV['MONGOHQ_URL'])
	conn = Mongo::Connection.from_uri(ENV['MONGOHQ_URL'])
	db = conn.db(uri.path.gsub(/^\//, ''))
else
  	db = Mongo::Connection.new('localhost').db('fuelprice')
end

get '/' do
	"A whole new world of Raaga information"
end