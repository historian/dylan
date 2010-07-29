class Post < Struct.new(:title, :body)

  def self.all
    @posts ||= [
      new('Hello Alice!', ''),
      new('Hello World!', '')
    ]
  end

  def self.find(id)
    all[id.to_i]
  end

end

