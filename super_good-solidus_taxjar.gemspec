lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "super_good/solidus_taxjar/version"

Gem::Specification.new do |spec|
  spec.name = "super_good-solidus_taxjar"
  spec.version = SuperGood::SolidusTaxjar::VERSION
  spec.authors = ["Jared Norman"]
  spec.email = ["jared@super.gd"]

  spec.summary = "Support for using TaxJar to handle tax calculations in Solidus"
  spec.description = spec.summary
  spec.homepage = "https://github.com/SuperGoodSoft/solidus_taxjar"
  spec.license = 'BSD-3-Clause'

  spec.required_ruby_version = ">= 2.5.0"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  files = Dir.chdir(__dir__) { `git ls-files -z`.split("\x0") }

  spec.files = files.grep_v(%r{^(test|spec|features)/})
  spec.test_files = files.grep(%r{^(test|spec|features)/})
  spec.bindir = "exe"
  spec.executables = files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "solidus_core", ">= 2.4.0"
  spec.add_dependency "solidus_support", ">= 0.9.0"
  spec.add_dependency "taxjar-ruby"
  spec.add_dependency "deface"

  spec.add_development_dependency "solidus_dev_support"
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rspec-rails"
  spec.add_development_dependency "vcr", "~> 4.0"
  spec.add_development_dependency "webmock"
end
