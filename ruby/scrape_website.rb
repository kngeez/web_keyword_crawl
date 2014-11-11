#!/usr/bin/ruby

require 'anemone'
require 'csv'
require 'uri'

keyword_list = ["compressor", "determined", "battery"]

keyword_list2 = ["nail bomb", "chemical bomb", "firework", "firecracker", "grenade", "handgun", "rifle", "shotgun", "hunting gun", "functioning antique gun", "airsoft gun", "paintball gun", "bb gun", "gun scope", "ammunition", "ammunition clip", "ammunition belt", "switchblade", "tactical knive", "fighting knive", "sword cane", "balisong", "military knive", "push dagger", "throwing axe", "weapon", "throwing star", "brass knuckle", "crossbow"]

keyword_found = false

csv_contents = CSV.read("websites.csv")
csv_contents = [['http://www.rozziproducts.com', '41-test']]

CSV.open("results.csv", "wb") do |csv|
  csv_contents.each do |row|
    line = row[0]
  
    keyword_found = false
    Anemone.crawl(line) do |anemone|
      anemone.on_every_page do |page|
        unless keyword_found
          url =  page.url
          html = page.body.downcase
          if keyword_list2.any?{ |k| html.include?(k) }
            puts "Keyword found on: " + url.to_s
            keyword_found = true
            csv << [url, row[1]]
          end
        else
          anemone.stop_crawl()
        end
      end
      
    end
  end
end
