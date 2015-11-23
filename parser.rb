require 'rubygems'
require 'nokogiri'
require 'restclient'

# WEB_STRING = "http://www.vape-room-cyprus.com/"
# WEB_STRING = "http://www.ejuices.co/collections/all-brands"
WEB_STRING = "http://www.ejuices.co/collections/all-brands"


def parse
  page = Nokogiri::HTML(RestClient.get(WEB_STRING))
  puts page.class # => Nokogiri::HTML::Document  puts page.class
end


if __FILE__ == $PROGRAM_NAME
  parse # => Nokogiri::HTML::Document
end