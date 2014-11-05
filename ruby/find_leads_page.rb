# find leads page and get website if one exists

require 'nokogiri'
require 'openssl'
require 'mechanize'
require 'open-uri'
require 'csv'

 mech = Mechanize.new
 mech.agent.http.verify_mode = OpenSSL::SSL::VERIFY_NONE

CSV.foreach("leadspages.csv") do |row|
  line = row[0]
  puts line
  
  doc = Nokogiri::HTML(open(line))
  search_path = doc.xpath("/html/head/link[3]").to_s().split("http://")[-1]
#  puts search_path
  if search_path == "microsite.marchex.com/css/ms_base.css\">"
    print "Leads page found: "
    puts doc.xpath("/html/body/div[1]/div[4]/div[1]/div/div/div[1]/div[2]/div[1]/div[1]/h4[5]/a").to_s().split("\" rel")[0].split("href=\"")[-1]
    puts ""
  else
    puts "Not a leads page."
    puts ""
  end

end

  
