module Dylan::Base

  def self.included(base)
    base.class_eval do
      extend Dylan::Actions
      include Dylan::Helpers
      include Dylan::Rendering
      include Tilt::CompileSite
    end
  end

  def initialize(*)
    router = self.class.router.clone
    router.routes.each { |route| route.compile }

    @_stack = Rack::Builder.app do
      use Dylan::Middleware::BrowserCache
      run router
    end

    @_templates = {}

    @_template = @_status = @_headers = \
      @_body = @_rendering = @_env = \
      nil
  end

  def call(env)
    dup._call(env)
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
