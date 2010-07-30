# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'dylan/version'

Gem::Specification.new do |s|
  s.name        = "dylan"
  s.version     = Dylan::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Simon Menke"]
  s.email       = ["simon.menke@gmail.com"]
  s.homepage    = "http://github.com/fd/dylan"
  s.summary     = "A more flexible sinatra."
  s.description = "Dylan the better Sinatra"

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "dylan"

  s.require_path = 'lib'
  s.files        = Dir.glob("{lib}/**/*") +
                   %w(LICENSE README.md)

  s.add_runtime_dependency 'rack'
  s.add_runtime_dependency 'http_router'
  s.add_runtime_dependency 'tilt'
end
