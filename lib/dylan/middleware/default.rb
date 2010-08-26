module Dylan::Middleware::Default

  def self.call(env)
    obj     = env['dylan']
    default = obj.instance_variable_get('@_default')
    default.call(env)
  end

end
