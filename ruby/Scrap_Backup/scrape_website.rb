#!/usr/bin/ruby

require 'rubygems'
require 'open-uri'
require 'openssl'
require 'mechanize'
require 'csv'

mech = Mechanize.new
mech.user_agent_alias = "Windows Mozilla"
mech.agent.http.verify_mode = OpenSSL::SSL::VERIFY_NONE

keyword_list = ["compressor", "determined", "battery"]

keyword_list = ["nail bomb", "chemical bomb", "firework", "firecracker", "grenade", "handgun", "rifle", "shotgun", "hunting gun", "functioning antique gun", "airsoft gun", "paintball gun", "bb gun", "gun scope", "ammunition", "ammunition clip", "ammunition belt", "switchblade", "tactical knive", "fighting knive", "sword cane", "balisong", "military knive", "push dagger", "throwing axe", "weapon", "throwing star", "brass knuckle", "crossbow"]

keyword_found = false
current_domain = ""
checked_domains = Array.new

# csv_contents = CSV.read("links.csv")
# csv_contents.shift

csv_contents = [["http://www.printingplace.ca/home.html", ]]
csv_contents = [["http://www.smith-wesson.com", ]]
csv_contents.each do |row|
  line = row[0]

  current_uri = URI(line)
  domain_parts = current_uri.host.split(".")
  puts "#{domain_parts[-2]}.#{domain_parts[-1]}"
  puts "Searching "

  html = mech.get(line).body
  if keyword_list.any?{|k| html.include?(k)}
    puts "Keyword found!"
    
  end
  
#  if keyword_found == true && !line.include?(current_domain)
  # if keyword_found == true && !checked_domains.include?(line.split('/')[2].split("www.")[-1].split('/')[0])
  #   keyword_found = false
  #   puts "Skipped to next URL."
  # end
  # if keyword_found == false
  #   #     html = open(line).read
  #   begin
  #     html = mech.get(line).body
  #   rescue Exception => e
  #     puts e
  #   else
  #     if keyword_list.any?{|k| html.include?(k)}
  #       puts "Keyword found!"
  #       puts line
  #       keyword_found = true
  #     end
  #   end
  #   current_domain = line.split('/')[2].split("www.")[-1].split('/')[0]
  #   checked_domains << current_domain
  #   puts "current domain:"
  #   puts current_domain
  # end
end

puts "Checked Domains:"
puts checked_domains
