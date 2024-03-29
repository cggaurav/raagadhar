#! encoding : 'UTF-8'
require 'sinatra'
require 'mongo'
require 'nokogiri'
require 'open-uri'
require 'json'
require 'timeout'
require 'pony'

def get_spotify_playlist(raaga)
#<iframe src="https://embed.spotify.com/?uri=spotify:trackset:PREFEREDTITLE:5Z7ygHQo02SUrFmcgpwsKW,1x6ACsKV4UdWS2FMuPFUiT,4bi73jCM02fMpkI11Lqmfe" frameborder="0" allowtransparency="true"></iframe>
	raaga.gsub!("try","")
	url = "http://ws.spotify.com/search/1/track.json?q=raga #{raaga}"
	html = ""
	begin
		html = (Nokogiri::HTML(open(URI.escape(url), {:read_timeout => 1, "User-Agent" => "Mozilla/5.0"})))
	rescue Exception => e
		puts "Oh my fucking God"
		puts e.inspect
		return nil
	end

	tracks = JSON.parse(html)["tracks"]

	if(tracks == [] and raaga.split(' ')[1])
		nxt = raaga.split(' ')[1]
		# puts nxt.inspect
		nxturl = "http://ws.spotify.com/search/1/track.json?q=raga #{nxt}"
		begin
			html = (Nokogiri::HTML(open(URI.escape(nxt), {:read_timeout => 1, "User-Agent" => "Mozilla/5.0"})))
		rescue Exception => e
			puts "Oh my fucking fucking God"
			puts e.inspect
			return nil
		end
	end
	tracks = JSON.parse(html)["tracks"]
	tracks.sort! { |a,b| a["popularity"] <=> b["popularity"]}
	list = []
	tracks[0..10].each do |i|
		list.push(i["href"].gsub("spotify:track:",""))
	end
	# puts list.inspect
	listcsv = list.join(",")
	listname = raaga.capitalize
	return_url = "https://embed.spotify.com/?uri=spotify:trackset:#{listname}:#{listcsv}"
	return_url
end

get '/' do
	erb :index
end

get '/about' do
	erb :about
end

get '/define/:raaga' do
	raaga = params[:raaga]
	puts raaga
	raaga.downcase!
	url = "http://index.bonsai.io/7bfy61vro8h8nothcjzz/definitions/_search?q=#{raaga}"
	json = JSON.parse(Nokogiri::HTML(open(URI.escape(url))))["hits"]["hits"]
	if(json[0])
		@definition = json[0]["_source"]
		@related = []
		@related.push(json[1]["_source"]) if json[1]
		@related.push(json[2]["_source"]) if json[2]
	else
		@definition = nil
	end
	erb :define
end


get '/raaga' do 
	raaga = params[:raaga]
	if(raaga == nil || raaga == "")
		redirect '/'
	else
		raaga.downcase!
		url = "http://index.bonsai.io/7bfy61vro8h8nothcjzz/test/_search/?q=name:#{raaga}"
		@raaga_json = JSON.parse(Nokogiri::HTML(open(URI.escape(url))))["hits"]["hits"]
		# puts @raaga_json
		if (@raaga_json !=[])
			erb :raaga 
		else
			redirect "/define/%s" %raaga
		end
	end
end


post '/submit' do
	puts params.inspect
	Pony.mail(
		:from => params[:email],
		:to => 'cggaurav@gmail.com',
		:subject => params[:name] + " has contacted you",
		:body => params[:feedback],
		:port => '587',
		:via => :smtp,
		:via_options => { 
		:address              => 'smtp.sendgrid.net', 
		:port                 => '587', 
		:enable_starttls_auto => true, 
		:user_name            => ENV['SENDGRID_USERNAME'], 
		:password             => ENV['SENDGRID_PASSWORD'], 
		:authentication       => :plain, 
		:domain               => ENV['SENDGRID_DOMAIN']
	})	
	redirect '/submit?status=true'
end

get '/submit' do
	@status = params[:status]
	erb :submit
end


