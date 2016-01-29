require "open-uri"
require 'phashion'

module DupFinder

  KNOWN_DUPS = ["Aloha eLiquids",
                "Apothecary Tonics",
                "Balls Vape",
                "Barz",
                "Cashmere Millionaires",
                "Cereal City Vapes",
                "Exodus",
                "Flavies Juicy Brew",
                "Fluids by Intellect",
                "Fuug Life",
                "Hot Cloudz",
                "Locked and Loaded E-Liquid",
                "Merkury",
                "Nautical Vapors",
                "Pinstripe Elixir",
                "Rig Reserve",
                "Saucy Drops",
                "The GodVapor",
                "The Fix e-Liquid",
                "The Neighborhood",
                "The Pale Whale",
                "The Vape Barrel",
                "TSL Flavors",
                "Utopia",
                "V8P Juice",
                "Vape Dudes",
                "VAPELYFE",
                "Vaporean",
                "Winners Circle",
                "YGRT eliquid"]

  DUP_COMPARE_NAME = 'dup_to_check.png'

  DOWNLOAD_IMAGE = "ejuice.png"

  def self.has_dup_images?(image_url)

    if image_url.empty?
      return false
    end
    image_url.gsub!("https", "http")
    File.open(DOWNLOAD_IMAGE, 'wb') do |fo|
      fo.write open(image_url).read
    end

    img1 = Phashion::Image.new(DUP_COMPARE_NAME)
    img2 = Phashion::Image.new(DOWNLOAD_IMAGE)
    img_duplicate = img1.duplicate?(img2)
    return img_duplicate
  end
end

def self.remove_file(file = DOWNLOAD_IMAGE)
  File.delete(file)
end

def first_option(brands)
  liq_hash = brands.first.liq_hash
  liquid = liq_hash.to_a[0][1]
  options = liquid.liquids_options
  opt = options[0]
end

if __FILE__ == $PROGRAM_NAME
  # brands = PageParser.load_brands("brand_one.bk")
  # option = first_option(brands)
  # is_dup = DupFinder.has_dup_images? option
  #
  # puts is_dup
end