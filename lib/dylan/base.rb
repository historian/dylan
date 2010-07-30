module Dylan::Base

  def self.included(base)
    base.class_eval do
      extend  Dylan::Routes
      include Dylan::Helpers
      include Dylan::Rendering
      include Tilt::CompileSite
    end
  end

  def initialize(*args)
    @_router = HttpRouter.new
    self.class.routes.each { |route| route.bind(self) }

    if args.first.respond_to?(:call)
      @_router.default args.shift
    end

    if Hash === args.first
      @_options = args.shift
    end

    @_stack = Rack::Builder.app do
      use Dylan::Middleware::BrowserCache
      run @_router
    end

    @_templates = {}

    @_template = @_status = @_headers = \
      @_body = @_rendering = @_env = \
      nil
  end

  def call(env)
    if env['PATH_INFO'] =~ /^\/?_/ and not env['dylan.internal']
      [403, {'Content-Type' => 'text/plain'}, ['Access denyed']]
    else
      dup._call(env)
    end
  end

  def _call(env)
    env['dylan'] = self
    @_stack.call(env)
  end

  def response
    [@_status, self.headers, @_body]
  end

  def template(path)
    @_templates[path] ||= Tilt.new(path)
  end

end
