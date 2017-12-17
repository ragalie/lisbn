require "multi_json"
require "nori"
require_relative "../lib/lisbn/ranges"

task :save_ranges_to_yaml do
  Lisbn::Ranges.save_to_yaml!
end
