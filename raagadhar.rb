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

def get_spotify_playlist(raaga)
#<iframe src="https://embed.spotify.com/?uri=spotify:trackset:PREFEREDTITLE:5Z7ygHQo02SUrFmcgpwsKW,1x6ACsKV4UdWS2FMuPFUiT,4bi73jCM02fMpkI11Lqmfe" frameborder="0" allowtransparency="true"></iframe>
	url = "http://ws.spotify.com/search/1/track.json?q=raga+#{raaga}"
	tracks = JSON.parse(Nokogiri::HTML(open(URI.escape(uri))))["tracks"]
	tracks.sort! { |a,b| a["popularity"] <=> b["popularity"]}
	list = []
	tracks.each do |i|
		list.push(i["href"].gsub("spotify:track:",""))
	end
	listcsv = list[0..9].join(",")
	return_url = "https://embed.spotify.com/?uri=spotify:trackset:#{raaga}:#{listcsv}"	
	puts return_url
	return_url
end

raagas = db.collection('raagas')
definitions = db.collection('definitions')
dictionary = db.collection('dictionary')

get '/' do
	erb :index
end

get '/define/:raaga' do
	@raaga = params[:raaga]
	erb :define
end


get '/raaga' do 
	raaga = params[:raaga].downcase
	if(raaga == nil)
		redirect '/'
	else
		@spotifylist = get_spotify_playlist(raaga)
		url = "http://index.bonsai.io/7bfy61vro8h8nothcjzz/test/_search/?q=name:#{raaga}"
		@raaga_json = JSON.parse(Nokogiri::HTML(open(URI.escape(url))))["hits"]["hits"]
		erb :raaga if (raaga and @raaga_json)
	end
end


get '/submit' do
	
end