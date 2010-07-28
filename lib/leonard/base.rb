module Leonard::Base

  def self.included(base)
    base.class_eval do
      extend Leonard::Actions
      include Leonard::Helpers
      include Leonard::Rendering
      include Tilt::CompileSite
    end
  end

  def initialize(*)
    @_router = self.class.router.clone
    @_router.routes.each { |route| route.compile }

    @_stack = @_router
    @_stack = Leonard::Caching::Client.new(@_stack)

    @_templates = {}

    @_template = @_status = @_headers = @_body = @_static_attributes = @_rendering, @_env = nil
  end

  def call(env)
    dup._call(env)
  end

  def _call(env)
    env['leonard'] = self
    @_stack.call(env)
  end

  def __call(env, action)
    _generate_etag(env) do |env|
      @_env = env
      invalid = catch(:halt) { __send__(action) ; true }
      raise "No response was given!" if invalid
      [@_status, self.headers, @_body]
    end
  end

  def _generate_etag(env)
    @_static_attributes = instance_variables
    resp = yield(env)

    if resp[0] == 200

      unless resp[1]['ETag']
        etag  = Digest::SHA1.new
        ivars = instance_variables - @_static_attributes
        ivars.inject(etag) do |digest, ivar|
          instance_variable_get(ivar).to_etag(digest)
        end
        etag  = etag.hexdigest

        resp[1]['ETag'] = etag
      end

    end

    resp
  end

  def template(path)
    @_templates[path] ||= Tilt.new(path)
  end

end
