require_relative 'liquid_option'
module PageParser

  class Eliquid
    attr_accessor :image
    attr_accessor :vg
    attr_accessor :descr
    attr_accessor :brand
    attr_accessor :title
    attr_accessor :options
    attr_accessor :price
    attr_accessor :volume
    attr_accessor :nic_level

    def initialize(liquids_images, liquids_vg, liquids_description, liquids_brand, liquids_title, liquids_option)
      @liquids_images, @liquids_vg, @liquids_description, @liquids_brand, @liquids_title= liquids_images, liquids_vg, liquids_description, liquids_brand, liquids_title
      @liquids_options = []
      liquids_option.each { |option_string|
        liquid_option = PageParser::LiquidOption.new(option_string, liquids_images)
        if liquid_option
          @liquids_options.push(liquid_option)
        end
      }
    end

  end
end

if __FILE__ == $PROGRAM_NAME
  # liq = PageParser::Eliquid.new("ima","vg","liq_desc","liq_brand","liqTitle","liqoption" ) # => Nokogiri::HTML::Document
  # liq.inspect
end
