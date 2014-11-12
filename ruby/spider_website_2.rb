#! /usr/bin/env ruby

require 'anemone'
require 'csv'
require 'nokogiri'
require 'open-uri'
require 'uri'

def is_leads_page(url)
  doc = Nokogiri::HTML(open(url, "User-Agent" => "Windows Mozilla"))
  search_path = doc.xpath("/html/head/link[3]").to_s().split("http://")[-1]

  if search_path == "microsite.marchex.com/css/ms_base.css\">"
    puts "Leads page found:"
    puts url
    website = doc.xpath("//h4[@class=\"link\"]/a/@href").to_s()
    if website != ""
      puts "Leads page website:"
      puts website
      puts ""
      return website
    end
  end
  puts "Not a leads page."
  puts ""
  return nil
end


def keyword_on_website(url)
  keyword_list = ["compressor", "flower", "responsibilities"]

  keyword_list2 = ["nail bomb", "chemical bomb", "firework", "firecracker" , "grenade", "handgun", "rifle", "shotgun", "hunting gun", "functioning antique gun", "airsoft gun", "paintball gun", "bb gun", "gun scope", "ammunition", "ammunition clip", "ammunition belt", "switchblade", "tactical knive", "fighting knive", "sword cane", "balisong", "military knive", "push dagger", "throwing axe", "weapon", "throwing star", "brass knuckle", "crossbow"]

  Anemone.crawl(url) do |anemone|
    anemone.on_every_page do |page|
      url =  page.url
      html = page.body.downcase
      if keyword_list2.any?{ |k| html.include?(k) }
        puts "Keyword found on: " + url.to_s()
        puts ""
        anemone.stop_crawl()
        return url.to_s()
      end
    end
  end
  return nil
end

def process_websites(input_file, output_file)
#  csv_contents = CSV.read(input_file)
  csv_contents = [["41-test", "http://www.alltypefireprotection.ca"]]
  CSV.open(output_file, "wb") do |csv|
    csv_contents.each do |row|
      landing_page = row[1]
      send_to_csv = [row[0], landing_page]

      keyword_website = keyword_on_website(landing_page)
      if keyword_website != nil
        send_to_csv[1] = keyword_website
        send_to_csv.push("yes")
      else
         leads_page_website = is_leads_page(landing_page)
        if leads_page_website != nil
          keyword_website = keyword_on_website(leads_page_website)
          if keyword_website != nil
            send_to_csv[1] = keyword_website
            send_to_csv.push("yes")
          else
            send_to_csv.push("no")
          end
        else
          send_to_csv.push("no")
        end
      end
      csv << (send_to_csv)
    end
  end
end

process_websites("test.csv", "results.csv")
