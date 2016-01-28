require "open-uri"
require_relative "liquid_option"
require_relative "ejuices_parser"
module DupFinder

  def has_dup_images?(option)

    image_url = option.image_url

    File.open('dup.png', 'wb') do |fo|
      fo.write open(image_url).read
    end

    # return false


  end


end

if __FILE__ == $PROGRAM_NAME
  brands = PageParser.load_brands("#{BRANDS_FILE}.bk")
  liq_hash = brands.first.liq_hash
  liquid = liq_hash.to_a[1]
  option = liquid.liquids_options.first
  is_dup = DupFinder.has_dup_images? option
end