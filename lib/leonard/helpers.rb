module Leonard::Helpers

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
    env = self.env.dup
    env['PATH_INFO'] = url

    if @_rendering
      status, headers, body = call(env)
      if status == 200
        content = ""
        body.each { |chunk| content << chunk }
        content
      else
        nil
      end
    else
      halt *call(env)
    end
  end

end
