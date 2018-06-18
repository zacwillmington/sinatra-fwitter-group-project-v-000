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
      if Helpers.is_logged_in?(session)
          redirect to '/tweets'
      end
      erb :'users/create_user'
  end

  post '/signup' do
      if Helpers.is_logged_in?(session)

          redirect to '/tweets'
      elsif Helpers.is_params_empty(params)

          redirect to '/signup'
      else
          @user = User.create(:username => params['username'], :email => params['email'], :password_digest => params['password'])
          session[:id] = @user.id

          redirect to '/tweets'
      end
  end

  get '/login' do
      binding.pry
      
      erb :'/users/login'
  end

  post '/login' do
      binding.pry

      redirect to "/tweets/#{@tweet.id}"
  end

  get '/tweets' do
       if Helpers.is_logged_in?(session)
          @user = Helpers.current_user(session)

          erb :'tweets/tweets'
       else
           redirect to "/"
          #flash message
       end
  end

  get '/tweets/new' do

      erb :'/tweets/create_tweet'
  end

  post '/tweets' do
     @tweet = Tweet.find_by(:content => params['content'])

     redirect to "/tweets/#{@tweet.id}"
  end

  get '/tweets/:id' do

      erb :'/tweets/show'
  end

  get '/tweets/:id/edit' do

      erb :'/tweets/edit_tweet'
  end

  post '/tweets/:id' do

       redirect to "/tweets/#{@tweet.id}"
  end
end
