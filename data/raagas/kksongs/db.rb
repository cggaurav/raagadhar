require 'mongo'
require 'yajl'

coll = Mongo::Connection.new('localhost').db('raagadhar').collection('raagas')

def translate_swara(swaras = [])
	if(swaras = [])
		return nil
	else
		swaras
	end
end

def split_swara(swaras = "")
	raw_swaras = swaras.gsub("(","").gsub(")","").gsub(' ','').strip.chomp
	raw_swaras = raw_swaras.gsub(","," ")
	puts raw_swaras
	(0...raw_swaras.length).each do |i|
		puts raw_swaras[i]
	end
end

file = Yajl::Parser.parse(File.open('kksongs.json','r', :encoding => 'utf-8').read())
file.each do |json|
	puts json["name"].capitalize!
	split_swara(json["Aroha"])
	coll.insert(json)
end