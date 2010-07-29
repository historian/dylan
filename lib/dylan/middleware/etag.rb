class Dylan::Middleware::ETag

  def initialize(app)
    @app = app
  end

  def call(env)
    obj          = env['dylan']
    static_ivars = obj.instance_variables

    resp = @app.call(env)

    return resp unless resp[0] == 200
    return resp if     resp[1]['ETag']

    etag  = Digest::SHA1.new
    ivars = obj.instance_variables - static_ivars
    ivars.inject(etag) do |digest, ivar|
      obj.instance_variable_get(ivar).to_etag(digest)
    end
    etag  = etag.hexdigest

    resp[1]['ETag'] = etag
    resp
  end

end
