require 'rubygems'
require 'nokogiri'
require 'restclient'

# WEB_STRING = "http://www.vape-room-cyprus.com/"
# WEB_STRING = "http://www.ejuices.co/collections/all-brands"
WEB_STRING = "http://ruby.bastardsbook.com/files/hello-webpage.html"


def parse
  page = Nokogiri::HTML(RestClient.get(WEB_STRING))
  puts page.class # => Nokogiri::HTML::Document  puts page.class
  xml = page.css('li')[2]
  links = page.css("a")

  l = links.map { |x| x["href"] }

  news_links = page.css("div#references a")
  news_links.each{|link| puts "#{link.text}\t#{link['href']}"}
  puts


end


if __FILE__ == $PROGRAM_NAME
  parse # => Nokogiri::HTML::Document
end