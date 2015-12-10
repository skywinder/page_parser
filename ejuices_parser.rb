require 'rubygems'
require 'nokogiri'
require 'restclient'

BASE_URL = 'http://www.ejuices.co'
WEB_STRING = "http://www.ejuices.co/collections/all-brands"


Eliqid = Struct.new(:image, :vg, :descr, :brand, :title, :options, :price, :volume, :nic_level) do
  def inspect
    puts "DESCR:\n#{title}\n#{vg}\n#{descr}\n#{brand}\n#{options}"
  end
end


Brand = Struct.new(:name, :link, :liquids) do
  def fetch_liquids
    page = Nokogiri::HTML(RestClient.get(self.link))
    page_css = page.css('div.product-inner')

    liquids_images = page_css.map { |product|
      product.css('img')[0].attr('src')
    }

    liquids_VG = page_css.map { |product|
      product.css('p')[1].css('span').text
    }
    liquids_Description = page_css.map { |product|
      product.css('p')[0].text
    }

    liquids_Brand = page_css.map { |product|
      product.css('p.brand').css('a')[0].text
    }

    liquids_Title = page_css.map { |product|
      product.css('p.title').css('a')[0].text
    }

    liquids_Option = page_css.map { |product|
      product.css('select').css('option').map { |option|
        option.text
      }
    }

    liquids_Option.each {|v|
      if v.count > 0

        v.each {|o|
          o_gsub = o.gsub(/\s+/, "")
          o_split1 = o_gsub.split(/(.*) \/ (.*) - $ (.*) /)

          o_split = o_gsub.split(/[,\/-]/)
          puts o_split
        }
      end
    }

    self.liquids = (0..liquids_Title.count).map do |i|
      if liquids_Title[i] and not liquids_Title[i].include? "Sample"
        Eliqid.new(liquids_images[i], liquids_VG[i], liquids_Description[i], liquids_Brand[i], liquids_Title[i], liquids_Option[i])
      end
    end
  end
end

def get_all_brands_links(page)
  dropdowns = page.css('ul.dropdown-wrap')
  brands= dropdowns[1]
  brands_links =brands.css('li.dropdown-item').map { |x| x.css('a') }
  brands_links

end

def parse
  page = Nokogiri::HTML(RestClient.get(WEB_STRING))
  brands_links = get_all_brands_links(page)
  all_brands_links = brands_links.map { |x| BASE_URL+x[0]['href'] }
  # puts all_brands_links
  all_brands_names = brands_links.map { |x| x[0].text }


  brands_links_take = all_brands_names.zip(all_brands_links).drop(1).take(3)
  # brands_links_take.each { |n, l| puts "#{n} #{l}" }

  all_brands = []
  brands_links_take.each { |b|
    brand_new = Brand.new(b[0], b[1])
    brand_new.fetch_liquids
    all_brands.push(brand_new)
  }

  all_brands.each { |b|

    b.liquids.each do |l|
      puts l.inspect
    end
  }
end


if __FILE__ == $PROGRAM_NAME
  parse # => Nokogiri::HTML::Document
end