#! /usr/bin/env ruby
# test spidr

require 'anemone'
# require 'open-uri'
# require 'openssl'
# require 'mechanize'

# mech = Mechanize.new
# mech.user_agent_alias = "Windows Mozilla"
# mech.agent.http.verify_mode = OpenSSL::SSL::VERIFY_NONE

keyword_found = false

Anemone.crawl('http://www.printingplace.ca') do |anemone|
  anemone.on_every_page do |page|
    unless keyword_found
      puts page.url
    
      if page.body.include?("Hours")
        puts "Keyword found!"
        keyword_found = true
      end
    end
  end
end

puts "test end"
