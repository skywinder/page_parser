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

  def parse(bk_filename)
    page = Nokogiri::HTML(RestClient.get(WEB_STRING))
    brands_links = PageParser.get_all_brands_links page
    all_brands_links = brands_links.map { |x| BASE_URL+x[0]['href'] }
    # puts all_brands_links
    all_brands_names = brands_links.map { |x| x[0].text }


    brands_links = all_brands_names.zip(all_brands_links)
    # brands_links.each { |n, l| puts "#{n} #{l}" }

    all_brands = []
    # brands = ["AESOP", "Barz", "Cuttwood"]
    if brands.empty?
      brands_links.each { |b|
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
      brands.each { |brand|
        b = brands_links.detect { |br| br[0].include? brand }
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
    end

    puts "saving brands"

    save_brands(all_brands, "#{bk_filename}-with_dup.bk")

    check_brands_for_dups(bk_filename, all_brands)

  end

  def check_brands_for_dups(bk_filename, all_brands=nil)
    if all_brands.nil?
      all_brands = PageParser.load_brands(bk_filename)
    end
    all_brands.each { |b|
      puts "check dup: #{b.name}"
      b.brand_check_for_dup
    }

    save_brands(all_brands, "#{bk_filename}")
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

FILENAME = "brands.bk"
# FILENAME = "brand_one.bk"
# FILENAME = "brand_AESOP.bk"

if __FILE__ == $PROGRAM_NAME

  # PageParser.parse "#{BRANDS_FILE}-#{Time.now.to_i}.bk"
  # PageParser.parse FILENAME
  PageParser.check_brands_for_dups FILENAME
  csv_from_file FILENAME
  # csv_from_file "brand_one.bk"
end