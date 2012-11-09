# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "tracey/version"

Gem::Specification.new do |gem|
  gem.name        = "tracey"
  gem.version     = Tracey::VERSION
  gem.authors     = ["Julio Santos"]
  gem.email       = ["julio@morgane.com"]
  gem.homepage    = ""
  gem.summary     = "Log events for tracing"
  gem.description = "Log events for tracing"

  gem.rubyforge_project = "tracey"

  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.require_paths = ["lib"]

  if RUBY_PLATFORM == "java"
    gem.add_runtime_dependency "jruby-openssl", '0.7.3'
  end

  gem.add_development_dependency "rake"
  gem.add_development_dependency "mocha", "0.12.1"
end
