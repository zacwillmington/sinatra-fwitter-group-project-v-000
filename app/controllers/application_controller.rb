require './config/environment'
require 'bcrypt'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public' # Over loaded? how to seprate?
    set :views, 'app/views'
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
      binding.pry
      if Helpers.is_logged_in?(session)
          redirect to '/tweets'
      elsif Helpers.is_params_empty?(params)
          redirect to '/signup'
      else
                    @user = User.create(:username => params['username'], :email => params['email'], :password => params['password'])
                     binding.pry
                    @user.blank?
                    @user.valid?
                    binding.pry
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

end
