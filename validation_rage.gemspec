# -*- encoding: utf-8 -*-
require File.expand_path('../lib/validation_rage/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Michael Bumann"]
  gem.email         = ["michael@railslove.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "validation_rage"
  gem.require_paths = ["lib"]
  gem.version       = ValidationRage::VERSION
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'mocha'
  gem.add_dependency 'activesupport'
  
end
