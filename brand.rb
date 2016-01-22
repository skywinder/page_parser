require_relative 'eliquid'

module PageParser
  class Brand

    attr_accessor :name
    attr_accessor :link
    attr_accessor :liquids

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

      liquids_brand = page_css.map { |product|

        product.css('p.brand').css('a')[0].text
      }


      liquids_title = page_css.map { |product|


        product.css('p.title').css('a')[0].text
      }

      liquids_option = page_css.map { |product|
        product.css('select').css('option').map { |option|
          option.text
        }
      }

      liquids_option.each { |v|
        if v.count > 0

          v.each { |o|
            o_gsub = o.gsub(/\s+/, "")
            o_split1 = o_gsub.split(/(.*) \/ (.*) - $ (.*) /)

            o_split = o_gsub.split(/[,\/-]/)
            # puts o_split
          }
        end
      }

      self.liquids = (0..liquids_title.count).map do |i|
        if liquids_title[i] and not liquids_title[i].include? "Sample"
          liquid = PageParser::Eliquid.new(liquids_images[i], liquids_vg[i], liquids_description[i], liquids_brand[i], liquids_title[i], liquids_option[i])
          liquid.inspect
        end
      end
      # end
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
