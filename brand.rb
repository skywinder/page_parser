require_relative 'eliquid'
require 'yaml'

module PageParser
  class Brand

    attr_accessor :name
    attr_accessor :link
    attr_accessor :liquids_title
    attr_accessor :liq_hash
    alias_method :title, :liquids_title

    # Brand = Struct.new(:name, :link, :liquids) do
    def initialize(name, link)
      @name, @link = name, link

    end

    def fetch_liquids
      page = Nokogiri::HTML(RestClient.get(self.link))
      page_css = page.css('div.product-inner')

      liquids_images = page_css.map { |product|
        product.css('img')[0].attr('src')
      }

      liquids_vg = page_css.map { |product|
        product.css('p')[1].css('span').text
      }
      liquids_description = page_css.map { |product|
        product.css('p')[0].text
      }

      # liquids_brand = page_css.map { |product|
      #
      #   product.css('p.brand').css('a')[0].text
      # }


      liquids_brand = []
      liquids_title = []
      page_css.each { |product|
        text = product.css('p.title').css('a')[0].text
        # text.encode!('UTF-8', :invalid => :replace, :undef => :replace)
        o_split = text.split(/\s[,\/-]\s/)
        fail "Params count wrong (should be 3): #{o_split}" if o_split.count < 2
        o_split.map! { |x|
          x.strip!
          x.gsub!(/[^\w\d\s-]/, '')
          x
        }
        liquids_brand.push(o_split[0])
        liquids_title.push(o_split[1])
      }

      liquids_option = page_css.map { |product|
        product.css('select').css('option').map { |option|
          option.text
        }
      }


      liquids = (0...liquids_title.count).map do |i|
        if liquids_title[i] and not liquids_title[i].include? "Sample"
          eliquid_new = PageParser::Eliquid.new(liquids_images[i], liquids_vg[i], liquids_description[i], liquids_brand[i], liquids_title[i], liquids_option[i])
          fail "nil liquid" if eliquid_new.nil?
          eliquid_new
        else
          nil
        end
      end
      liquids.compact!

      @liq_hash = self.merge_liquids(liquids)
    end

    # @return [Hash]
    def merge_liquids(liquids)
      liquids_hash = {}
      liquids.each do |liquid|
        if liquids_hash.has_key? liquid.liquids_title
          liquids_hash[liquid.liquids_title].add_options(liquid)
        else
          liquids_hash[liquid.liquids_title] = liquid
        end
      end
      liquids_hash
    end

  end

  module_function

  def get_all_brands_links(page)
    dropdowns = page.css('ul.dropdown-wrap')
    brands= dropdowns[1]
    brands_links =brands.css('li.dropdown-item').map { |x| x.css('a') }
    brands_links
  end
end

if __FILE__ == $PROGRAM_NAME
  # PageParser.parse # => Nokogiri::HTML::Document
end
