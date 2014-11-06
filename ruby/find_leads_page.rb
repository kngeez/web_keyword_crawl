
# find leads page and get website if one exists

require 'nokogiri'
require 'openssl'
require 'mechanize'
require 'open-uri'
require 'csv'

mech = Mechanize.new
mech.agent.http.verify_mode = OpenSSL::SSL::VERIFY_NONE

allowed_domains = ""
start_urls = ""

CSV.open("websites.csv", "wb") do |csv| # write to new csv file
  CSV.foreach("leadspages.csv") do |row| # read from leadspages.csv
    line = row[0]
    puts line
    csv << [line]

    allowed_domains += "\'" + line.split("http://")[-1].split("www.")[-1].split("/")[0] + "\', "
    start_urls += "\'" + line + "\', "

    doc = Nokogiri::HTML(open(line))
    search_path = doc.xpath("/html/head/link[3]").to_s().split("http://")[-1]

    if search_path == "microsite.marchex.com/css/ms_base.css\">"
      print "Leads page found: "
      website = doc.xpath("/html/body/div[1]/div[4]/div[1]/div/div/div[1]/div[2]/div[1]/div[1]/h4[5]/a").to_s().split("\" rel")[0].split("href=\"")[-1]
      puts website
      csv << [website]

      allowed_domains += "\'" + website.split("http://")[-1].split("www.")[-1].split("/")[0] + "\', "
      start_urls += "\'" + website + "\', "

      puts ""
    else
      puts "Not a leads page."
      puts ""
    end
  end
end

puts "Allowed Domains:"
puts allowed_domains[0..-3]
puts ""
puts "Start URLs:"
puts start_urls[0..-3]

File.open("domains.txt", 'w') do |out|
  out.puts "Allowed Domains:"
  out.puts allowed_domains[0..-3]
  out.puts ""
  out.puts "Start URLs:"
  out.puts start_urls[0..-3]
end
