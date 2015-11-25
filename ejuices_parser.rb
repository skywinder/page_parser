require 'rubygems'
require 'nokogiri'
require 'restclient'

BASE_URL = 'http://www.ejuices.co'
WEB_STRING = "http://www.ejuices.co/collections/all-brands"


def get_all_brands_links(page)
  dropdowns = page.css('ul.dropdown-wrap')
  brands= dropdowns[1]
  brands_links =brands.css('li.dropdown-item').map { |x| x.css('a') }
  # brands_links.each {
  #     |li| puts li[0]['href']
  # }
  brands_links
  # puts page.search('li.dd-li')
  # puts brands_links.count

end

def parse
  page = Nokogiri::HTML(RestClient.get(WEB_STRING))
  brands_links = get_all_brands_links(page)
  all_brands_links = brands_links.map { |x| BASE_URL+x[0]['href'] }
  # puts all_brands_links
  all_brands_names = brands_links.map { |x| x[0].text }

  all_brands_names.zip(all_brands_links).take(3).each { |n, l| puts "#{n} #{l}" }

end


if __FILE__ == $PROGRAM_NAME
  parse # => Nokogiri::HTML::Document
end