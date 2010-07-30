class Shared < Dylan

  get '/header' do
    render 'templates/header.erb'
  end

  get('/static').static('public')

  add('/*').to do |env|
    [404, {}, []]
  end

end
