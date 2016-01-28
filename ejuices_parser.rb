require 'rubygems'
require 'restclient'
require 'nokogiri'
require 'yaml'

require_relative 'brand'
require_relative 'csv_exporter'

module PageParser
  BASE_URL = 'http://www.ejuices.co'
  WEB_STRING = "http://www.ejuices.co/collections/all-brands"

  BRANDS_FILE = './brands'

  module_function

  def parse(filename)
    page = Nokogiri::HTML(RestClient.get(WEB_STRING))
    brands_links = PageParser.get_all_brands_links page
    all_brands_links = brands_links.map { |x| BASE_URL+x[0]['href'] }
    # puts all_brands_links
    all_brands_names = brands_links.map { |x| x[0].text }


    brands_links = all_brands_names.zip(all_brands_links)
    # brands_links.each { |n, l| puts "#{n} #{l}" }

    all_brands = []
    brand = "Barz"
    if brand.nil?
      brands_links.take(1).each { |b|
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
    else
      b = brands_links.detect{|br| br[0].include? brand}
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
    end


    save_brands(all_brands, filename)
    puts all_brands
  end


  def save_brands(all_brands, filename)
    File.open(filename, 'w') { |f| f.write(YAML.dump(all_brands)) }
  end

  def self.load_brands(filename)
    YAML.load(File.read(filename))
  end
end


def csv_from_file(filename)
  brands = PageParser.load_brands(filename)
  PageParser::CSVExporter.export_to_csv brands
end

if __FILE__ == $PROGRAM_NAME

  # PageParser.parse "#{BRANDS_FILE}-#{Time.now.to_i}.bk"
  PageParser.parse "brand_one.bk"
  # csv_from_file "brands.bk"
end