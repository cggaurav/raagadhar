require 'mongo'
require 'patron'

coll = Mongo::Connection.new('localhost').db('raagadhar').collection('raagas')

i = coll.find_one()
i.delete("_id")

puts i

sess = Patron::Session.new
sess.base_url = "http://index.bonsai.io/7bfy61vro8h8nothcjzz"
#sess.headers['User-Agent'] = 'curl/7.21.4 (universal-apple-darwin11.0) libcurl/7.21.4 OpenSSL/0.9.8r zlib/1.2.5'
sess.headers['Host'] =  "index.bonsai.io"
#curl/7.21.4 (universal-apple-darwin11.0) libcurl/7.21.4 OpenSSL/0.9.8r zlib/1.2.5
sess.enable_debug "/tmp/patron.debug"

#resp = sess.get("/test/1")
#puts resp.body

sess.put("/test/100", 'hello world', {"Content-Type" => "application/json"})

