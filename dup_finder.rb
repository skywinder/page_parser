require "open-uri"
require 'phashion'

require_relative "liquid_option"
require_relative "ejuices_parser"
module DupFinder

  DUP_IMG_NAME = 'dup.png'

  STUB_IMAGE = "ejuices.png"

  def self.has_dup_images?(option)

    image_url = option.image_url
    image_url.gsub!("https", "http")
    File.open(DUP_IMG_NAME, 'wb') do |fo|
      fo.write open(image_url).read
    end

    img1 = Phashion::Image.new(DUP_IMG_NAME)
    img2 = Phashion::Image.new(STUB_IMAGE)
    img_duplicate = img1.duplicate?(img2)
    return img_duplicate
  end

  def remove_file(file)
    File.delete(file)
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