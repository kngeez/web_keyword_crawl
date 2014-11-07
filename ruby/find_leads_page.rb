
# find leads page and get website if one exists

require 'nokogiri'
require 'open-uri'
require 'csv'


allowed_domains = ""
start_urls = ""

#def add_to_csv(csv, line, id, allowed_domains, start_urls)
#  puts "line in method:"
#  puts line
#  csv << [line, id]
#  allowed_domains += "\'" + line.split("http://")[-1].split("www.")[-1].split("/")[0] + "\', "
#  start_urls += "\'" + line + "\', "
#end


CSV.open("websites.csv", "wb") do |csv| # write to new csv file
  CSV.foreach("landing_pages_test.csv") do |row| # read from leadspages.csv
    line = row[0]

    csv << [line, row[1]]
    allowed_domains += "\'" + line.split("http://")[-1].split("www.")[-1].split("/")[0] + "\', "
    start_urls += "\'" + line + "\', "

#    add_to_csv(csv, line, row[1], allowed_domains, start_urls)

    doc = Nokogiri::HTML(open(line))
    search_path = doc.xpath("/html/head/link[3]").to_s().split("http://")[-1]

    if search_path == "microsite.marchex.com/css/ms_base.css\">"
      puts "Leads page found:"
      puts line
      website = doc.xpath("//h4[@class=\"link\"]/a/@href").to_s()
      if website != ""
        puts "Leads page website:"
        puts website

        csv << [website, row[1]]
        allowed_domains += "\'" + website.split("http://")[-1].split("www.")[-1].split("/")[0] + "\', "
        start_urls += "\'" + website + "\', "
        
#        add_to_csv(csv, website, row[1], allowed_domains, start_urls)
   
      end
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
