# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "contracted/version"

Gem::Specification.new do |s|
  s.name        = "api-testing"
  s.version     = Contracted::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Andrew Kiellor"]
  s.email       = ["akiellor@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Contracted is a set of cucumber steps to define HTTP based API's.}
  s.description = %q{Contracted is a set of cucumber steps to define HTTP based API's.}

  s.rubyforge_project = "contracted"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.add_dependency('cucumber')
  s.add_dependency('thin')
  s.add_dependency('rest-client')
  s.add_dependency('activesupport')
  s.add_dependency('rspec')
end
