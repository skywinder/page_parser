require "open-uri"
require_relative "liquid_option"
require_relative "ejuices_parser"
module DupFinder

  def self.has_dup_images?(option)

    image_url = option.image_url

    File.open('dup.png', 'wb') do |fo|
      fo.write open(image_url).read
    end

    # return false


  end


end

def first_option(brands)
  liq_hash = brands.first.liq_hash
  liquid = liq_hash.to_a[0][1]
  options = liquid.liquids_options
  opt = options[0]
end

if __FILE__ == $PROGRAM_NAME
  brands = PageParser.load_brands("brand_one.bk")
  option = first_option(brands)
  is_dup = DupFinder.has_dup_images? option
end