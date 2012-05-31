require 'mongo'
require 'patron'
require 'json'

class BSON::OrderedHash
  def to_h
    inject({}) { |acc, element| k,v = element; acc[k] = (if v.class == BSON::OrderedHash then v.to_h else v end); acc }
  end

  def to_json
    to_h.to_json
  end
end

$base_url = "http://index.bonsai.io/7bfy61vro8h8nothcjzz"
#coll = Mongo::Connection.new('localhost').db('raagadhar').collection('raagas')
#curl/7.21.4 (universal-apple-darwin11.0) libcurl/7.21.4 OpenSSL/0.9.8r zlib/1.2.5
sess = Patron::Session.new
sess.headers['User-Agent'] = 'Gaurav/1.1'
sess.headers['Host'] =  "index.bonsai.io"
sess.enable_debug "/tmp/patron.debug"
sess.timeout = 10000

def delete_all(index)
	#Delete all ids
	sess = Patron::Session.new
	sess.headers['User-Agent'] = 'Gaurav/1.1'
	sess.headers['Host'] =  "index.bonsai.io"
	sess.enable_debug "/tmp/patron_delete.debug"
	sess.timeout = 10000
	(0..101).each do |i|
		sess.delete($base_url+"/#{index}/#{i}")
	end
end

def insert(index)
	sess = Patron::Session.new
	sess.headers['User-Agent'] = 'Gaurav/1.1'
	sess.headers['Host'] =  "index.bonsai.io"
	sess.enable_debug "/tmp/patron_insert.debug"
	sess.timeout = 10000
	coll.find().each_with_index do |i,j|
		hash = i.to_h
		puts hash.inspect
		hash.delete("_id")
		hash["name"] = hash["name"].gsub("_"," ").capitalize
		json = hash.to_json
		puts json.inspect
		sess.post($base_url+"/#{index}/#{j}", json , {"Content-Type" => "application/x-www-form-urlencoded"})
	end
end

def definitions()
	sess = Patron::Session.new
	sess.headers['User-Agent'] = 'Gaurav/1.1'
	sess.headers['Host'] =  "index.bonsai.io"
	sess.enable_debug "/tmp/patron_insert.debug"
	sess.timeout = 100
	file = File.open('data/define.csv','r',:encoding => 'UTF-8')
	file.each_with_index do |csv,j|
		name = csv.split(';')[0]
		definition = csv.split(';')[1]
		url = csv.split(';')[2]
		hash= {"name" => name, "url" => url, "definition" => definition}
		json = hash.to_json
		puts json.inspect
		sess.post($base_url+"/definitions/#{j}", json , {"Content-Type" => "application/x-www-form-urlencoded"})
	end
end

definitions()
