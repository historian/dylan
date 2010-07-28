# vim: set ft=ruby:
$:.unshift File.expand_path('../../lib', __FILE__)
require 'leonard'
require 'blog'

run Blog.new
