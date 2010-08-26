module Dylan::Configuration
  
  attr_accessor :templates_path
  
  def templates_path
    @templates_path || (superclass.templates_path rescue nil) || 'templates'
  end
  
  def templates_path=(path)
    @templates_path = File.expand_path(path)
  end
  
end