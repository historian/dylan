# vim: set ft=ruby:

require "rubygems"
require "bundler/setup"

require 'dylan'
require 'models'
require 'albums/comments'
require 'albums/categories'
require 'albums/shared'
require 'albums/blog'

run Blog.new
