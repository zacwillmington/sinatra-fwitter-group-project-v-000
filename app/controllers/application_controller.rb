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

  get '/signup' do
      erb :'users/create_user'
  end

  post '/signup' do #CREATE HELPER METHODS  
      binding.pry #checks if user has account already, then create user.
      #set session_id

      redirect to "/tweets"
  end

  get '/tweets' do
      #with session user_id
      #checks if user is logged_in
      #if current_user

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
