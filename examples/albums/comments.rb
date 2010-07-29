class Comments < Dylan

  get '/post/:id' do
    @comments = Comment.where(:post_id => params[:id]).all
    render 'comments'
  end

end
