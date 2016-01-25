module PageParser
  class LiquidOption
    attr_accessor :bottle_size
    attr_accessor :nic_level
    attr_accessor :wholesale_price

    def initialize(option, img)
      o_gsub = option.gsub(/\s+/, "")
      o_split = o_gsub.split(/[,\/-]/)
      @bottle_size, @nic_level, @wholesale_price = o_split
      @image_url = img
    end
  end
end