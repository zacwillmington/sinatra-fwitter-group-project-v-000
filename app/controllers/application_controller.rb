require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "secret"
  end

  get '/' do
      erb :index
  end

  get '/users/signup' do
      erb :'user/create_user'
  end

  post '/users/signup' do
      binding.pry
      erb :'/users/show'
  end

  get '/tweets' do

      erb :'/tweets/tweets'
  end

  get '/tweets/new' do
      erb :'/tweets/create_tweet'
  end

  post '/tweets' do
     binding.pry
     @tweet = Tweet.find_by(:content => params['content'])
     redirect to :"/tweets/#{@tweet.id}"
  end

  get '/tweets/:id' do

      erb :'/tweets/show'
  end

  get '/tweets/:id/edit' do

      erb :'/tweets/edit_tweet'
  end

  post '/tweets/:id' do

       redirect to :"/tweets/#{@tweet.id}"
  end



end
