#! /usr/bin/env ruby
# find leads page and get website if one exists

require 'nokogiri'
require 'open-uri'
require 'csv'


CSV.open("websites.csv", "wb") do |csv| # write to new csv file
  CSV.foreach("initial_test_data.csv") do |row| # read from leadspages.csv
    line = row[0]
    csv << [line, row[1]]
 
    doc = Nokogiri::HTML(open(line, "User-Agent" => "Windows Mozilla"))
    search_path = doc.xpath("/html/head/link[3]").to_s().split("http://")[-1]

    if search_path == "microsite.marchex.com/css/ms_base.css\">"
      puts "Leads page found:"
      puts line
      website = doc.xpath("//h4[@class=\"link\"]/a/@href").to_s()
      if website != ""
        puts "Leads page website:"
        puts website
        csv << [website, row[1]]
       end
      puts ""
    else
      puts "Not a leads page."
      puts ""
    end
  end
end
