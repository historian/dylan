class Dylan::Middleware::Action

  def initialize(action)
    @action = action
  end

  def call(env)
    obj     = env['dylan']

    unless env['dylan.internal'] or obj.public_methods.include?(@action)
      return [405, {}, ['Access denyed']]
    end

    obj.instance_variable_set('@_env', env)
    invalid = catch(:halt) { obj.__send__(@action) ; true }
    raise "No response was given!" if invalid

    obj.response
  end

end
