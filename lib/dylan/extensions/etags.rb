class Object

  def to_etag(digest=Digest::SHA1.new)
    instance_variables.inject(digest) do |memo, ivar|
      memo = memo << ivar.to_s
      instance_variable_get(ivar).to_etag(memo)
    end
  end

end

module Enumerable

  def to_etag(digest=Digest::SHA1.new)
    inject(digest) do |memo, value|
      value.to_etag(memo)
    end
  end

end

class String

  def to_etag(digest=Digest::SHA1.new)
    digest << self
  end

end
