require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "sl_secret"
  end

  get '/' do
    erb :landing
  end
  #directs to landing page at initial launch 

  helpers do 
    def logged_in?
      !!current_user 
    end 

    def current_user
      @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
    end 

    def allow_user_edit?(sneaker)
      if logged_in? && current_user.id == sneaker.user_id 
        if params[:brand] == "" || params[:model] == "" || params[:colorway] == "" || params[:cost] == ""
          redirect to "/sneakers/#{params[:id]}/edit"
        else
          sneaker = Sneaker.find(params[:id])
          if sneaker && sneaker.user == current_user # allow_user_edit?(@sneaker)
              if sneaker.update(brand: params[:brand], model: params[:model], colorway: params[:colorway], cost: params[:cost])
                  redirect to "/sneakers/#{sneaker.id}"
              else 
                  redirect to "/sneakers/#{sneaker.id}/edit"
              end 
          else 
              redirect to '/sneakers'
          end 
        end
      else 
        redirect to '/login'
      end 
    end 
  end 

end
