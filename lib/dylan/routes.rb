module Dylan::Routes

  def routes
    @routes ||= (superclass.routes.clone rescue [])
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

  def add(path, options=nil, &block)
    route = Route.new(self, :add, [path, options], nil, block)
    self.routes << route
    route
  end

  class Route

    def initialize(klass, method, args, rblock, block)
      @klass      = klass
      @calls      = []
      @action     = nil
      @has_action = false

      record method, args, rblock, block
    end

    def method_missing(method, *args, &block)
      if HttpRouter::RequestNode::RequestMethods.include?(method)
        condition(method => args)
      else
        super
      end
    end

    def with_options(options, &block)
      record :with_options, [options], nil, block
    end

    def name(name, &block)
      record :name, [name], nil, block
    end

    def default(v, &block)
      record :default, [v], nil, block
    end

    def get(&block)
      record :get, [], nil, block
    end

    def post(&block)
      record :post, [], nil, block
    end

    def head(&block)
      record :head, [], nil, block
    end

    def put(&block)
      record :put, [], nil, block
    end

    def delete(&block)
      record :delete, [], nil, block
    end

    def condition(conditions, &block)
      record :condition, [conditions], nil, block
    end
    alias_method :conditions, :condition

    def matching(match)
      record :matching, [match], nil, block
    end

    def to(dest=nil, &block)
      guard_against_duplicate_actions
      @has_action = true
      record :to, [dest], block, nil
    end

    def partial(match=true, &block)
      record :partial, [match], nil, block
    end

    def arbitrary(proc=nil, &block)
      record :arbitrary, [proc], block, nil
    end

    def redirect(path, status=302)
      guard_against_duplicate_actions
      @has_action = true
      record :redirect, [path, status], nil, nil
    end

    def static(root)
      guard_against_duplicate_actions
      @has_action = true
      record :static, [root], nil, nil
    end

    def bind(instance)
      if @action
        action = Rack::Builder.app do
          use Dylan::Middleware::ETag
          run Dylan::Middleware::Action.new(@action)
        end

        record(:to, [action], nil, nil)

        @action = nil
      end

      method, args, block = *@initial_call
      route = instance.router.__send__(method, *args, &block)

      @calls.each do |(method, args, block)|
        route = route.__send__(method, *args, &block)
      end

      route
    end

    private

    def guard_against_duplicate_actions
      if @has_action
        raise "Two different actions were added. A route can only handle a single action."
      end
    end

    def define_action_method(block)
      method = Digest::SHA1.hexdigest(eval('[__FILE__, __LINE__]', block).join(':'))
      @klass.send :define_method, method, &block
      method
    end

    def record(m, args, rblock, block)
      if block
        guard_against_duplicate_actions
        @has_action = true
        @action = define_action_method(block)
      end

      unless @initial_call
        @initial_call = [m, args, rblock]
      else
        @calls << [m, args, rblock]
      end

      self
    end

  end

end
