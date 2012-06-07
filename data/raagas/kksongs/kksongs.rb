#encoding:utf-8
require 'open-uri'
require 'nokogiri'
require 'json'
# Raga Name: Bairagi
# That Name: Bhairava
# Aroha: S r m P n S’
# Avaroha: S’ n P m P m r S ‘n S
# Jati: Audava – Audava
# Vadi: m
# Samvadi: S
# Swarupa: m P n P m r 'n r S
# Prahar: 3rd Prahar (9 AM to 12 PM) 
# Raga Information:
# Raga Bairagi, also known as Raga Bairaga Bhairava, is a raga based on the South Indian raga, Revati. Some say this raga was introduced by Ravi Shankar, although there are many musicians who refute this idea, saying that the origins of this raga in the North Indian system was found well before Ravi Shankar. Nonetheless, Raga Bairagi has an enchanting and devotional property, beyond most of the Bhairava That ragas. The raga contains five notes with a great level of harmony between each notes, S, r, m, P, n and S. This raga is heard usually in light classical musical areas and devotional settings. Many hymns of Lord Siva are found in this raga, as this is considered a Bhairava that.
 
url = "http://kksongs.org/raga/list/"
raaga_all = []
rlist = File.open("kksongs.list",'w')
html = Nokogiri::HTML(open(url))
html.css('a').each do |link|
	raaga_name = link.text
	if raaga_name.end_with? '.html'
		raaga_link = ("http://kksongs.org/raga/list/" + raaga_name) 
		puts raaga_link
		html = Nokogiri::HTML(open(raaga_link))
		raaga = {}
		raaga["name"] = raaga_name
		raaga["url"] = raaga_link
		(5..15).each do |i|
			attribute = html.xpath("/html/body/div[1][@class='Section1']/p[#{i}]").text
			# puts i
			# puts attribute
			if(attribute.include?"Information")
				raaga["Information"] = html.xpath("/html/body/div[1][@class='Section1']/p[15]").text
			else	
				begin
					raaga[attribute.split(':')[0].gsub(" Name","").chomp.strip] = attribute.split(':')[1].chomp.strip if attribute.include? ":"	
				rescue Exception => e
					next
				end				
			end
		end
		raaga_all.push(raaga)
	end
end

rlist.write(raaga_all.to_json)