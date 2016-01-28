require_relative 'dup_finder'

module PageParser
  class LiquidOption
    attr_reader :image_url
    attr_accessor :bottle_size
    attr_accessor :nic_level
    attr_accessor :wholesale_price

    def initialize(option, img)
      o_gsub = option.gsub(/\s+/, "")
      o_split = o_gsub.split(/[,\/-]/)
      @bottle_size, @nic_level, @wholesale_price = o_split
      @image_url = "#{img}"
    end

    MULTIPLIER = 2.0

    def check_dup
      if DupFinder.has_dup_images? self
        @image_url = ""
      end
    end

    def retailing_price
      price = @wholesale_price.gsub(/[^\d\.]/, '')
      price_double = price.to_f * MULTIPLIER
      price_double
    end

    def bottle_size_num
      bottle_size_gsub = @bottle_size.gsub(/\D/, '')
      bottle_size_gsub
    end

    def image_url
      "https:#{@image_url}"
    end
  end
end