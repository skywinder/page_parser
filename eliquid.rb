require 'colorize'
require_relative 'liquid_option'
module PageParser

  class Eliquid
    attr_reader :liquids_description
    @@empty_liquids = []
    attr_accessor :liquids_title
    attr_accessor :liquids_options

    alias_method :options, :liquids_options

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

    def add_options(liquid)
      self.options.concat(liquid.options).compact!
    end


    def to_csv
      if self.liquids_options.count == 0
        puts "#{@liquids_brand} options id NIL!".red
        @@empty_liquids.push(@liquids_title)
        return []
      end
      self.liquids_options.each {|o| o.check_dup }
      opts = self.liquids_options.dup
      str = self.fill_first_string(opts.shift)
      csv_arr = [str]
      opts.each { |option|
        csv_arr.push(self.fill_next_strings(option))
      }
      csv_arr
    end

    def fill_next_strings(option)
      # code here
      "#{self.get_handle},,,,,,,,#{option.bottle_size},,#{option.nic_level},,#{@liquids_vg},\"\",#{option.bottle_size_num},shopify,#{DEF_AMOUNT},continue,manual,#{option.retailing_price},,true,true,,#{option.image_url},#{self.img_descr},,,,,,,,,,,,,,,,,,g"
      #acer-dulcia,,,,,,,,07ml,,03mg,,50pg/50vg,""                                                                     ,15,shopify,29,continue,manual,4.99,,true,true,,,,,,,,,,,,,,,,,,,,,g
    end

    DEF_AMOUNT = "0"

    TYPE = "E Liquid"

    TAG = "e-Juice preorder"

    def fill_first_string(option)
      "#{self.get_handle},#{self.liquids_title},\"#{self.liquids_description}\",\"#{@liquids_brand}\",#{TYPE},\"#{TAG},#{@liquids_vg}\",true,Bottle Size,#{option.bottle_size},Nicotine Level,#{option.nic_level},PG/VG Ratio,#{@liquids_vg},\"\",#{option.bottle_size_num},shopify,#{DEF_AMOUNT},continue,manual,#{option.retailing_price},,true,true,,#{option.image_url},#{self.img_descr},false,,,,,,,,,,,,,,,,,g"
      # "Handle,Title,Body (HTML),Vendor,                                                  Type,         Tags,                         Published,Option1 Name,Option1 Value,Option2 Name,Option2 Value,Option3 Name,Option3 Value,           Variant SKU,Variant Grams,Variant Inventory Tracker,Variant Inventory Qty,Variant Inventory Policy,Variant Fulfillment Service,
      #                                                                                                                                                                                                                                                                                                                  Variant Price,Variant Compare At Price,Variant Requires Shipping,Variant Taxable,Variant Barcode,Image Src,Image Alt Text,Gift Card,SEO Title,SEO Description,Google Shopping / Google Product Category,Google Shopping / Gender,Google Shopping / Age Group,Google Shopping / MPN,Google Shopping / AdWords Grouping,Google Shopping / AdWords Labels,Google Shopping / Condition,Google Shopping / Custom Product,Google Shopping / Custom Label 0,Google Shopping / Custom Label 1,Google Shopping / Custom Label 2,Google Shopping / Custom Label 3,Google Shopping / Custom Label 4,Variant Image,Variant Weight Unit\n"
      # "acer-dulcia,Acer Dulcia,<p>Subt,"",true,Size,07ml,Nicotine Level,03mg,PG/VG Ratio,20pg/80vg,"",15,shopify,22,continue,manual,4.99,,true,true,,https://cdn.shopify.com/s/files/1/1026/5581/products/Acer-Dulcia.jpeg?v=1451296908,Acer Dulcia - Cloud Alchemist E Liquid,false,,,,,,,,,,,,,,,,,g"
    end

    def liquids_description
      @liquids_description.gsub("\"", "'")
    end

    def img_descr
      string = "#{@liquids_brand} - #{@liquids_title} - #{TYPE}"
      string
    end

    def get_handle
      brandliquids_title_downcase_gsub = "#{@liquids_brand}-#{@liquids_title}"
      brandliquids_title_downcase_gsub.downcase!
      brandliquids_title_downcase_gsub.gsub!(/\p{^Alnum}/, '-')
      brandliquids_title_downcase_gsub
    end

  end
end

if __FILE__ == $PROGRAM_NAME
  # liq = PageParser::Eliquid.new("ima","vg","liq_desc","liq_brand","liqTitle","liqoption" ) # => Nokogiri::HTML::Document
  # liq.inspect
end
