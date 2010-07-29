module Dylan::Helpers

  def env
    @_env
  end

  def params
    env['router.params']
  end

  def headers
    @_headers ||= { 'Content-Type' => 'text/html' }
  end

  def halt(status, headers=nil, body=nil)
    @_status  = status.to_i
    @_headers = headers if headers
    @_body    = body || []

    throw(:halt)
  end

  def get(url)
    fetch(:get, url)
  end

  def fetch(method, url)
    env      = self.env.dup
    req      = Rack::Request.new(env)
    base_url = URI.parse(req.url)
    url      = base_url.merge(url)

    env['HTTP_HOST']      = "#{url.host}:#{url.port}"
    env['REQUEST_METHOD'] = method.to_s.upcase
    env['REQUEST_PATH']   = url.path if env['REQUEST_PATH']
    env['PATH_INFO']      = url.path.sub(/^#{Regexp.escape(env['SCRIPT_NAME'])}/, '')
    env['QUERY_STRING']   = url.query
    env['dylan.internal'] = true

    if @_rendering
      status, headers, body = call(env)
      if status == 200
        content = ""
        body.each { |chunk| content << chunk }
        content
      else
        puts [status, headers, body]
        nil
      end
    else
      halt *call(env)
    end
  end

end
