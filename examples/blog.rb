class Blog < Leonard

  get '/' do
    get '/page/0'
  end

  get '/page/:page' do
    @posts = Post.all
    halt 404 if @posts.empty?
    render 'page.erb'
  end

  get '/post/:id' do |id|
    @post = Post.find(id)
    render 'post'
  end

  get '_/post/:id/tags' do
    @tags = Post.find(params[:id]).tags
    render 'tags'
  end

  class Shared < Leonard

    get '/header' do
      render 'header.erb'
    end

  end

  class Comments < Leonard

    get '/post/:id' do
      @comments = Comment.where(:post_id => params[:id]).all
      render 'comments'
    end

  end

  add('_/shared/*').to(Shared.new)
  add('_/comments/*').to(Comments.new)

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
end
