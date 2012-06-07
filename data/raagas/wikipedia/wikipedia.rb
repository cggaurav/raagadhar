require 'nokogiri'
require 'open-uri'
require 'mongo'
url = "http://en.wikipedia.org/wiki/Melakartha"

html = Nokogiri::HTML(open(url))

def is_numeric?(i)
    i.to_i.to_s == i || i.to_f.to_s == i
end

coll = Mongo::Connection.new('localhost').db('raagadhar').collection("raagas")
# html.css('.wikitable td').each do |i|
# 	puts i.text.inspect  if !is_numeric?(i.text)
# end

file = File.open("wikipedia_janya.list","r")
json = {}
file.each_with_index do |csv,i|
	csv = csv.strip.chomp.gsub("\"","")
	if(i%2 ==0)
		puts json
		coll.insert(json) if (coll!={} and coll.find({"name" => csv}).count == 0)
		json = {}
		json ["name"] = csv
		url = URI.escape("http://en.wikipedia.org/wiki/#{csv}")
		html = Nokogiri::HTML(open(url))
		json ["url"] = url
		puts url.inspect
		
	else
		csv = csv.strip.chomp.gsub("\"","")
		swara = csv.split(" ")
		json["Swarupa"] = swara
		json["Aroha"] = swara
		json["Arohana"] = swara.reverse 
		json["Information"] = html.xpath("/html/body/div/div/div[@id='mw-content-text']/p[1]").text.gsub(/\[.*\]/,"").gsub(/\(.*\)/,"") 
		json["Related Information"] = html.xpath("/html/body/div/div/div[@id='mw-content-text']/p[2]").text.gsub(/\[.*\]/,"") + "\n" + html.xpath("/html/body/div/div/div[@id='mw-content-text']/ul").text.gsub(/\[.*\]/,"") + "\n" + html.xpath("/html/body/div/div/div[@id='mw-content-text']/p[3]").text.gsub(/\[.*\]/,"")
	end
end