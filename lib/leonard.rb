class Leonard

  require 'erb'
  require 'tilt'
  require 'http_router'
  require 'digest/sha1'

  require 'leonard/base'
  require 'leonard/actions'
  require 'leonard/rendering'
  require 'leonard/caching'
  require 'leonard/helpers'

  require 'leonard/etags'

  include Leonard::Base

end
