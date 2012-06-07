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

file = File.open('define.csv','r',:encoding => 'utf-8')
file.each do |csv|
	json = {}
	json["name"] = csv.split(';')[0]
	json["definition"] = csv.split(';')[1]
	json["url"] = csv.split(';')[2]
	json = json.to_json
	# sess.post("http://index.bonsai.io/7bfy61vro8h8nothcjzz"+"/definitions/", json , {"Content-Type" => "application/x-www-form-urlencoded"})
end