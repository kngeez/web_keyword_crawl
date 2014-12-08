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
    # puts "Leads page found:"
    # puts url
    website = doc.xpath("//h4[@class=\"link\"]/a/@href").to_s()
    if website != ""
      # puts "Leads page website:"
      # puts website
      # puts ""
      return website
    end
  end
  # puts "Not a leads page."
  # puts ""
  return nil
end


def keyword_on_website(url)
  keyword_list = ["nail bomb", "chemical bomb", "firework", "firecracker", "grenade",
                  "handgun", "rifle", "shotgun", "hunting gun", "functioning antique gun",
                  "airsoft gun", "paintball gun", "bb gun", "gun scope", "ammunition",
                  "ammunition clip", "ammunition belt", "switchblade", "tactical knive",
                  "tactical knife", "fighting knive", "fighting knife", "sword cane",
                  "balisong", "military knive", "military knife", "push dagger",
                  "throwing axe", "weapon", "throwing star", "brass knuckle", "crossbow"]

  pages = 0
  Anemone.crawl(url) do |anemone|
    anemone.on_every_page do |page|
      if pages > 500
        puts "Max pages reached for: " + url
        anemone.stop_crawl()
        return [url, "max pages reached"]
      end
      
      page_url =  page.url
      html = page.body
      if html != nil
        html = html.downcase
        for k in keyword_list
          if html.include?(k)
            anemone.stop_crawl()
            return [page_url.to_s(), k]
          end
        end
      else
        puts "No HTML"
        puts page_url.to_s()
        puts ""
      end
      pages += 1
    end
  end
  return nil
end


def process_websites(input_file, output_file)
  csv_contents = CSV.read(input_file)
#  csv_contents = [["41-test", "http://www.dandy.ca"]]
  CSV.open(output_file, "wb") do |csv|
    csv << ["CID-AID", "Webpage Keyword Appears", "Keyword Found?", "Keyword"]
    csv_contents.each do |row|
      puts "Processing: " + row[0]
      landing_page = row[1]
      send_to_csv = [row[0], landing_page]

      keyword_website = keyword_on_website(landing_page)
      if keyword_website != nil
        send_to_csv[1] = keyword_website[0]
        if keyword_website[1] == "max pages reached"
          send_to_csv << ("no")
        else
          send_to_csv << ("yes")
        end
        send_to_csv << keyword_website[1]
      else
        leads_page_website = is_leads_page(landing_page)
        if leads_page_website != nil
          keyword_website = keyword_on_website(leads_page_website)
          if keyword_website != nil
            send_to_csv[1] = keyword_website[0]
            if keyword_website[1] == "max pages reached"
              send_to_csv << ("no")
            else
              send_to_csv << ("yes")
            end
            send_to_csv << keyword_website[1]
          else
            send_to_csv << ("no")
          end
        else
          send_to_csv << ("no")
        end
      end
      csv << (send_to_csv)
    end
  end
end


process_websites("Website_List_1.csv", "results.csv")
