module Dylan::Templates

  def self.included(base)
    base.extend ClassMethods
  end

  def template(path)
    self.class.template(path)
  end
  
  module ClassMethods
    
    def templates
      @templates ||= (superclass.templates.dup rescue {})
    end

    def template(path)
      path = File.expand_path(path, self.templates_path)
      self.templates[path] ||= Tilt.new(path)
    end
    
  end
  
end