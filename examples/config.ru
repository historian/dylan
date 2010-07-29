# vim: set ft=ruby:
$:.unshift File.expand_path('../../lib', __FILE__)
require 'dylan'
require 'models'
require 'albums/comments'
require 'albums/categories'
require 'albums/shared'
require 'albums/blog'

run Blog.new
