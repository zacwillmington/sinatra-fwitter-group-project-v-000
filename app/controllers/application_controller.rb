require './config/environment'
require 'bcrypt'

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
      elsif Helpers.is_params_empty?(params)
          redirect to '/signup'
      else

          @user = User.create(:username => params['username'], :email => params['email'], :password => params['password'])
          session[:id] = @user.id
          redirect to '/tweets'
      end
  end

  get '/login' do
      if Helpers.is_logged_in?(session)
          redirect to '/tweets'
      else
          erb :'/users/login'
      end
  end

  post '/login' do
       @user = User.find_by(:username => params['username'])
       if @user == nil
           redirect to '/signup'
       elsif @user.authenticate(params['password'])
           session[:id] = @user.id
           redirect to "/tweets"
       end
  end

  get '/logout' do
         session.clear
         redirect to '/login'
  end

  get '/users/:slug' do
          @user = User.find_by_slug(params[:slug])
          erb :'/users/show'
  end



  get '/tweets' do
       if Helpers.is_logged_in?(session)
          @user = Helpers.current_user(session)
          @tweets = Tweet.all
          erb :'tweets/tweets'
       else
           redirect to "/login"

       end
  end

  get '/tweets/new' do
      if Helpers.is_logged_in?(session)
          erb :'/tweets/create_tweet'
      else
          redirect to '/login'
      end
  end

  post '/tweets' do
     if Helpers.is_logged_in?(session) && params['content'] != ""
         @user = Helpers.current_user(session)
         @tweet = Tweet.create(:content => params['content'], :user_id => @user.id)
         @user.save
         redirect to "/tweets"
     else
         redirect to "/tweets/new"
     end
  end

  get '/tweets/:id' do
      @tweet = Tweet.find_by(:id => params[:id])
      if Helpers.is_logged_in?(session) && @tweet != nil
          @user = Helpers.current_user(session)
          erb :'/tweets/show_tweet'
      else
          redirect to "/login"
      end
  end

  delete '/tweets/:id/delete' do
      @tweet = Tweet.find(params[:id])
      @user = Helpers.current_user(session)
      if @user.tweets.include?(@tweet)
          @tweet.delete
          redirect to '/tweets'
      else
          redirect to "/tweets/#{@tweet.id}"
      end
  end

  get '/tweets/:id/edit' do
      @tweet = Tweet.find_by(:id => params[:id])
      @user = Helpers.current_user(session)
      if Helpers.is_logged_in?(session)
          erb :'/tweets/edit_tweet'
      else
          redirect to "/login"
      end
  end

  patch '/tweets/:id/edit' do
      @tweet = Tweet.find(params[:id])
      @user = Helpers.current_user(session)
      if params['content'] != "" && @user.tweets.include?(@tweet) && Helpers.is_logged_in?(session)
          @tweet.content = params['content']
          @tweet.save
           redirect to "/tweets/#{@tweet.id}"
      else
          redirect to "/tweets/#{@tweet.id}/edit"
      end
  end

end
