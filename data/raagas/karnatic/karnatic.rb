require 'nokogiri'
require 'open-uri'
require 'mongo'
require 'json'
require 'patron'

class BSON::OrderedHash
  def to_h
    inject({}) { |acc, element| k,v = element; acc[k] = (if v.class == BSON::OrderedHash then v.to_h else v end); acc }
  end

  def to_json
    to_h.to_json
  end
end

sess = Patron::Session.new
sess.headers['Host'] =  "index.bonsai.io"
sess.enable_debug "/tmp/patron_insert.debug"
sess.timeout = 10000

# puts sess.delete("http://index.bonsai.io/7bfy61vro8h8nothcjzz"+"/definitions/")

base_url = "http://www.karnatik.com/"
urls = %w(A B C D E F G H I J K L M N O P Q R S T U V W X Y Z)
definitions = []
urls.each do |i|
	url = base_url + "gloss" + i.downcase + ".shtml"
	url = URI.escape(url);
	html = Nokogiri::HTML(open(url))
	html.css("td:nth-child(2) p").each do |j|
		j.text.gsub("\r","").split("\n").each do |k|
			if (k!="" and !k.include?"Questions?" and k)
				json = {}
				json["name"] = k.split(" - ",2)[0] if (k.split(" - ",2)[0])
				json["definition"] = k.split(" - ",2)[1].capitalize if (k.split(" - ",2)[1])
				json["url"] = url
				if(json["name"] and json["name"].gsub(" ","").size!=0 and json["definition"] and json["definition"].gsub(" ","").size!=0 )
					
					json = json.to_json
					puts json.inspect
					definitions.push(json);
					# sess.post("http://index.bonsai.io/7bfy61vro8h8nothcjzz"+"/definitions/", json , {"Content-Type" => "application/x-www-form-urlencoded"})
				end
			end
		end
	end
end

File.open("karnatic.glossary.json","w").write(definitions.to_json)