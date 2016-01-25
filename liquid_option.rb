module PageParser
  class LiquidOption
    attr_accessor :bottle_size
    attr_accessor :nic_level
    attr_accessor :wholesale_price

    def initialize(option)
      o_gsub = option.gsub(/\s+/, "")
      o_split = o_gsub.split(/[,\/-]/)
      @bottle_size, @nic_level, @wholesale_price = o_split
      # puts o_split

    end
  end
end