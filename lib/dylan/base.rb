module Dylan::Base

  def self.included(base)
    base.class_eval do
      extend  Dylan::Routes
      extend  Dylan::Configuration
      include Dylan::Helpers
      include Dylan::Templates
      include Dylan::Rendering
      include Tilt::CompileSite
    end
  end

  def initialize(*args)
    if args.first.respond_to?(:call)
      @_default = args.shift
    end

    @_template = @_status    = @_headers = \
    @_body     = @_rendering = @_env     = \
      nil
  end

  def call(env)
    if env['PATH_INFO'] =~ /^\/?_/ and not env['dylan.internal']
      [403, {'Content-Type' => 'text/plain'}, ['Access denyed']]
    else
      dup._call(self, env)
    end
  end

  def _call(prototype, env)
    env['dylan.prototype'] = prototype
    env['dylan'] = self
    @_prototype = prototype
    
    self.class.stack.call(env)
  end

  def response
    [@_status, @_headers, @_body]
  end

end
