require 'rubygems'
require 'open-uri'
require 'csv'

keyword_list = ["compressor", "determined"]

keyword_list2 = ["nail bomb", "chemical bomb", "firework", "firecracker", "grenade", "handgun", "rifle", "shotgun", "hunting gun", "functioning antique gun", "airsoft gun", "paintball gun", "bb gun", "gun scope", "ammunition", "ammunition clip", "ammunition belt", "switchblade", "tactical knive", "fighting knive", "sword cane", "balisong", "military knive", "push dagger", "throwing axe", "weapon", "throwing star", "brass knuckle", "crossbow"]

keyword_found = false
current_domain = ""

csv_contents = CSV.read("links.csv")
csv_contents.shift
csv_contents.each do |row|
  line = row[0]
  
  if keyword_found == true && !line.include?(current_domain)
    keyword_found = false
    puts "Skipped to next URL."
  else
    if keyword_found == false
      puts line
      html = open(line).read
      if keyword_list.any?{|k| html.include?(k)}
        puts "Keyword found!"
        keyword_found = true
      end
    end
    current_domain = line.split('/')[2].split("www.")[-1]
  end
end
