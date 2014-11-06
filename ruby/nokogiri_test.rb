# http://www.peachcitypestcontrol.ca

require 'nokogiri'
require 'open-uri'

doc = Nokogiri::HTML(open("http://www.peachcitypestcontrol.ca"))
puts doc.xpath("//h4[@class=\"link\"]/a/@href").to_s()




