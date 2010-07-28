module Leonard::Actions

  def router
    @router ||= (superclass.router.clone rescue HttpRouter.new)
  end

  def get(path, options={}, &block)
    add(path, options, &block).get
  end

  def head(path, options={}, &block)
    add(path, options, &block).head
  end

  def post(path, options={}, &block)
    add(path, options, &block).post
  end

  def put(path, options={}, &block)
    add(path, options, &block).put
  end

  def delete(path, options={}, &block)
    add(path, options, &block).delete
  end

  def add(path, options={}, &block)
    route = self.router.add(path, options)

    if block
      method = path.to_s
      define_method(method, &block)
      route = route.to do |env|
        env['leonard'].__call(env, method)
      end
      route.instance_variable_set('@paths', nil)
    end

    route
  end
end
