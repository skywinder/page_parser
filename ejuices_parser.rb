require 'rubygems'
require 'restclient'
require 'nokogiri'
# require './brand'
require_relative 'brand'

module PageParser
  BASE_URL = 'http://www.ejuices.co'
  WEB_STRING = "http://www.ejuices.co/collections/all-brands"

  module_function

  def parse
    page = Nokogiri::HTML(RestClient.get(WEB_STRING))
    brands_links = PageParser.get_all_brands_links(page)
    all_brands_links = brands_links.map { |x| BASE_URL+x[0]['href'] }
    # puts all_brands_links
    all_brands_names = brands_links.map { |x| x[0].text }


    brands_links_take = all_brands_names.zip(all_brands_links).drop(1).take(3)
    # brands_links_take.each { |n, l| puts "#{n} #{l}" }

    all_brands = []
    brands_links_take.each { |b|
      brand_new = Brand.new(b[0], b[1])
      brand_new.fetch_liquids
      all_brands.push(brand_new)
    }

    all_brands.each { |b|

      b.liquids.each do |l|
        puts l.inspect
      end
    }
  end
end


if __FILE__ == $PROGRAM_NAME
  PageParser.parse # => Nokogiri::HTML::Document
end