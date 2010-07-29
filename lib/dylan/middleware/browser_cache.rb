class Dylan::Middleware::BrowserCache

  def initialize(app)
    @app = app
  end

  def call(env)
    entity = @app.call(env)

    entity[1]['Cache-Control'] ||= 'public'
    entity[1]['Expires'] ||= (Time.now.utc + (60 * 60)).rfc2822.sub(/[-]?0000$/, 'GMT')

    if env['HTTP_PRAGMA'] == 'no-cache'
      return entity
    end

    if env['HTTP_CACHE_CONTROL'] == 'no-cache'
      return entity
    end

    if etag = entity[1]['ETag'] and env['HTTP_IF_NONE_MATCH'] == etag
      return [304, {}, []]
    end

    if lm = entity[1]['Last-Modified'] and env['HTTP_IF_MODIFIED_SINCE'] == lm
      return [304, {}, []]
    end

    return entity
  end

end
