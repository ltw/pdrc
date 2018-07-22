# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'pdrc/version'

Gem::Specification.new do |s|
  s.name        = "pdrc"
  s.version     = PDRC::VERSION
  s.authors     = ["Lucas Willett", "Amro Mousa"]
  s.email       = ["me@ltw.io", "amromousa@gmail.com"]
  s.homepage    = "http://github.com/ltw/pdrc"

  s.summary     = %q{A wrapper for the Pagerduty REST API v2}
  s.description = %q{A wrapper for the Pagerduty REST API v2}
  s.license     = "MIT"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.required_ruby_version = '>= 2.0.0'

  s.add_dependency('faraday', '>= 0.9.1')
  s.add_dependency('multi_json', '>= 1.11.0')

  s.add_development_dependency 'rake'
  s.add_development_dependency "rspec", "3.7.0"
  s.add_development_dependency 'webmock', '~> 1.21.0'
end
