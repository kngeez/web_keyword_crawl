#! /usr/bin/env ruby

require 'csv'
require 'anemone'
require 'nokogiri'
require 'open-uri'
require 'uri'

def find_leads_page(input_file, output_file)
  CSV.open(output_file, "wb") do |csv| # write to new csv file
    CSV.foreach(input_file) do |row| # read from leadspages.csv
      line = row[1]
      csv << [row[0], line]
      
      doc = Nokogiri::HTML(open(line, "User-Agent" => "Windows Mozilla"))
      search_path = doc.xpath("/html/head/link[3]").to_s().split("http://")[-1]
      
      if search_path == "microsite.marchex.com/css/ms_base.css\">"
        puts "Leads page found:"
        puts line
        website = doc.xpath("//h4[@class=\"link\"]/a/@href").to_s()
        if website != ""
          puts "Leads page website:"
          puts website
          csv << [row[0], website]
        end
        puts ""
      else
        puts "Not a leads page."
        puts ""
      end
    end
  end
end

def scrape_website(input_file, output_file)

  keyword_list = ["compressor", "flower", "responsibilities"]

  keyword_list2 = ["nail bomb", "chemical bomb", "firework", "firecracker" , "grenade", "handgun", "rifle", "shotgun", "hunting gun", "functioning antique gun", "airsoft gun", "paintball gun", "bb gun", "gun scope", "ammunition", "ammunition clip", "ammunition belt", "switchblade", "tactical knive", "fighting knive", "sword cane", "balisong", "military knive", "push dagger", "throwing axe", "weapon", "throwing star", "brass knuckle", "crossbow"]

  keyword_found = false

  csv_contents = CSV.read(input_file)
 # csv_contents = [["41-test", "http://www.rozziproducts.com"]]

  CSV.open(output_file, "wb") do |csv|
    csv_contents.each do |row|
      line = row[1]
  
      keyword_found = false
      Anemone.crawl(line) do |anemone|
        anemone.on_every_page do |page|
          unless keyword_found
            url =  page.url
            html = page.body.downcase
            if keyword_list.any?{ |k| html.include?(k) }
              puts "Keyword found on: " + url.to_s()
              keyword_found = true
              csv << [row[0], url]
            end
          else
            anemone.stop_crawl()
          end
        end
      end
    end
  end
end


find_leads_page("initial_test_data.csv", "websites.csv")

scrape_website("websites.csv", "results.csv")
