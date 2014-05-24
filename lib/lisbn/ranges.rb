class Lisbn < String
  module Ranges
    def self.to_yaml
      xml = Nori.new.parse(
          File.read(File.dirname(__FILE__) + '/../../data/RangeMessage.xml')
      )

      ranges = xml["ISBNRangeMessage"]["RegistrationGroups"]["Group"]

      hash = Array(ranges).flatten.inject({}) do |memo, group|
        prefix = group["Prefix"].gsub(/-/, '')
        ranges = Array(group["Rules"]["Rule"]).flatten.map do |rule|
          length = rule["Length"].to_i
          next unless length > 0

          {:range => Range.new(*rule["Range"].split("-").map {|r| r[0..(length - 1)].to_i }), :length => length}
        end.compact

        memo.update(prefix => ranges)
      end

      YAML::dump(hash)
    end

    def self.save_to_yaml!
      File.open(File.dirname(__FILE__) + "/../../data/ranges.yml", "w") do |f|
        f.write(to_yaml)
      end
    end
  end
end
