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

  post '/signup' do
      binding.pry
      if Helpers.is_logged_in?(session)
          binding.pry
          redirect to :'/tweets'
     elsif params['username'] == "" || params['email'] == "" || params['password'] == ""
         binding.pry
         redirect to :'/signup'
     else
          binding.pry
            @user = User.create(:username => params['username'], :email => params['email'], :password_digest => params['password'])
            session[:id] = @user.id
            redirect to :'/tweets'
      end
  end

  get '/tweets' do
      binding.pry

      if Helpers.is_logged_in?(session)
          binding.pry
          @user = User.find(session[:id])
          erb :'tweets/tweets'
      else
          redirect to :"/"
          #flash message
      end
  end

  get '/tweets/new' do
      erb :'/tweets/create_tweet'
  end
  
  post '/tweets' do
    #  binding.pry
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
