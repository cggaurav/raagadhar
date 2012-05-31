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

#curl/7.21.4 (universal-apple-darwin11.0) libcurl/7.21.4 OpenSSL/0.9.8r zlib/1.2.5
sess = Patron::Session.new
sess.headers['User-Agent'] = 'Gaurav/1.1'
sess.headers['Host'] =  "index.bonsai.io"
sess.enable_debug "/tmp/patron.debug"

coll = Mongo::Connection.new('localhost').db('raagadhar').collection('raagas')

coll.find().each_with_index do |i,j|
	hash = i.to_h
	puts hash.inspect
	hash.delete("_id")
	json = hash.to_json
	puts json.inspect
	sess.post("http://index.bonsai.io/7bfy61vro8h8nothcjzz/test/#{j}", json , {"Content-Type" => "application/x-www-form-urlencoded"})
end