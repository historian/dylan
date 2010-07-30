class Dylan

  require 'erb'
  require 'tilt'
  require 'http_router'
  require 'digest/sha1'

  require 'dylan/version'
  require 'dylan/base'
  require 'dylan/routes'
  require 'dylan/rendering'
  require 'dylan/helpers'

  module Middleware
    require 'dylan/middleware/action'
    require 'dylan/middleware/browser_cache'
    require 'dylan/middleware/etag'
  end

  require 'dylan/extensions/etags'

  include Dylan::Base

end
