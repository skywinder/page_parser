require 'rubygems'
require 'restclient'
require 'nokogiri'
require_relative 'brand'

module PageParser
  BASE_URL = 'http://www.ejuices.co'
  WEB_STRING = "http://www.ejuices.co/collections/all-brands"

  BRANDS_FILE = './brands.bk'

  module_function

  def parse
    page = Nokogiri::HTML(RestClient.get(WEB_STRING))
    brands_links = PageParser.get_all_brands_links(page)
    all_brands_links = brands_links.map { |x| BASE_URL+x[0]['href'] }
    # puts all_brands_links
    all_brands_names = brands_links.map { |x| x[0].text }


    brands_links_take = all_brands_names.zip(all_brands_links)
    # brands_links_take.each { |n, l| puts "#{n} #{l}" }

    all_brands = []
    brands_links_take.each { |b|
      name = b[0]
      link = b[1]
      puts "Parse brand: #{name}"
      new_brand = Brand.new(name, link)
      begin
        new_brand.fetch_liquids
      rescue => e
        puts "FAIL_TO_PARSE"
        puts e
      end

      all_brands.push(new_brand)
    }

    save_brands(all_brands)
    puts all_brands
  end


  def save_brands(all_brands)
    File.open("#{BRANDS_FILE}-#{Time.now.to_i}", 'w') { |f| f.write(YAML.dump(all_brands)) }
  end

  def self.load_brands
    YAML.load(File.read(BRANDS_FILE))
  end
end


if __FILE__ == $PROGRAM_NAME
  PageParser.parse # => Nokogiri::HTML::Document
  # brands = PageParser.load_brands
end