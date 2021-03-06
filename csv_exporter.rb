require_relative "eliquid"

module PageParser
  class CSVExporter

    CSV_FILE = "to_import"

    def self.export_to_csv(brands)
      csv_array = [first_string]

      puts "brands: #{brands.count}"

      brands.compact!
      puts "brands: #{brands.count}"

      brands.each { |brand|
        puts "Export: #{brand.name}"
        begin
          brand.liq_hash.each { |liquid|
            if liquid[1].nil?
              puts "ERROR #{liquid[0]} is nil!"
              break
            end
            begin
              csv_array.concat(liquid[1].to_csv)
            rescue => e
              puts "FAIL_TO_EXPORT #{liquid[0]}"
              puts e
            end
          }
        rescue => e
          puts "FAIL_TO_EXPORT #{brand.name}"
          puts e
        end

      }

      string = csv_array.join("\n")
      self.write_scv(string)
    end

    def self.write_scv(data)
      # code here
      filename_csv = "#{CSV_FILE}-#{Time.now.to_i}.csv"
      File.open(filename_csv, 'w') { |f| f.write(data) }
      puts "Save #{filename_csv} complete"
    end

    def self.first_string
      "Handle,Title,Body (HTML),Vendor,Type,Tags,Published,Option1 Name,Option1 Value,Option2 Name,Option2 Value,Option3 Name,Option3 Value,Variant SKU,Variant Grams,Variant Inventory Tracker,Variant Inventory Qty,Variant Inventory Policy,Variant Fulfillment Service,Variant Price,Variant Compare At Price,Variant Requires Shipping,Variant Taxable,Variant Barcode,Image Src,Image Alt Text,Gift Card,SEO Title,SEO Description,Google Shopping / Google Product Category,Google Shopping / Gender,Google Shopping / Age Group,Google Shopping / MPN,Google Shopping / AdWords Grouping,Google Shopping / AdWords Labels,Google Shopping / Condition,Google Shopping / Custom Product,Google Shopping / Custom Label 0,Google Shopping / Custom Label 1,Google Shopping / Custom Label 2,Google Shopping / Custom Label 3,Google Shopping / Custom Label 4,Variant Image,Variant Weight Unit"
    end
  end
end
