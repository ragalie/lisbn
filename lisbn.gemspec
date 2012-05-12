# -*- encoding: utf-8 -*-
Gem::Specification.new do |gem|
  gem.authors       = ["Mike Ragalie"]
  gem.email         = ["michael.ragalie@verbasoftware.com"]
  gem.description   = %q{ISBN manipulation helpers}
  gem.summary       = %q{Provides methods for converting between ISBN-10 and ISBN-13, checking validity and hyphenating ISBNs}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "lisbn"
  gem.require_paths = ["lib"]
  gem.version       = "0.0.1"

  gem.add_dependency "nori"
  gem.add_development_dependency "rspec"
end
