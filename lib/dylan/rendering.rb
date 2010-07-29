module Dylan::Rendering

  def each(&block)
    @_rendering = true
    @_body   = [@_template.render(self)] if @_template
    @_body ||= []
    @_body.each(&block)
  end

  def render(template, options={})
    @_template = self.template(template)

    halt(options[:status]  || 200,
         options[:headers],
         self)
  end

end
