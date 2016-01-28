require "open-uri"
require_relative "liquid_option"

module DupFinder

  def has_dup_images? option

    image_url = option.image_url

    File.open('pie.png', 'wb') do |fo|
      fo.write open(image_url).read
    end

    # return false


  end


end