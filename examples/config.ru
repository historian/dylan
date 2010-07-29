# vim: set ft=ruby:
$:.unshift File.expand_path('../../lib', __FILE__)
require 'dylan'
require 'blog'

run Blog.new
