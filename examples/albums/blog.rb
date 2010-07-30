class Blog < Dylan

  # public action
  get('/').name(:index) do
    # forward this request to a different resource (without redirecting)
    get url(:page, :page => 0)
  end

  # public action with parameter
  get('/page/:page').name(:page) do
    @posts = Post.all
    halt 404 if @posts.empty?
    render 'templates/page.erb'
  end

  # public action
  get '/post/:id' do |id|
    @post = Post.find(id)
    render 'post'
  end

  # private action
  get '_/post/:id/tags' do
    @tags = Post.find(params[:id]).tags
    render 'tags'
  end

  # public sub album
  add('categories/*').to(Categories.new)

  # private sub albums
  add('_/shared/*').to(Shared.new)
  add('_/comments/*').to(Comments.new)

  add('assets/*').host(/^assets\./).to(Assets.new)

end
