class UsersController < ApplicationController 

    get '/users/:slug' do 
        @user = User.find_by_slug(params[:slug])
        erb :'users/index'
    end 

    get '/signup' do 
        if !logged_in?
            erb :'users/signup'
        else 
            redirect to '/sneakers'
        end 
    end 
    #returns the sign up form, if they're not logged in. 

    post '/signup' do 
        if params[:username] == "" || params[:email] == "" || params[:password] == ""
            redirect to '/signup'
        else 
            @user = User.new(:username => params[:username], :email => params[:email], :password => params[:password])
            # binding.pry
            @user.save 
            session[:user_id] = @user.id 
            redirect to '/sneakers'
        end 
    end 
    #returns user to sign up page if they leave the fields empty. if user fills it out correctly it saves the user to db and redirect to their index page. 

    get '/login' do 
        if !logged_in?
            erb :'users/login'
        else 
            session[:user_id] = @user.id 
            redirect to '/sneakers/:user_id'
        end 
    end 
    #returns user login page. 

    post '/login' do 
        user = User.find_by(username: params[:username])
        if user && user.authenticate(params[:password])
            session[:user_id] = user.id
            redirect to '/sneakers'
        else 
            redirect to '/signup'
        end 
    end 
    #allows user to sign in after authentication. 

    get '/logout' do 
        if logged_in?
            session.clear
            redirect to '/login'
        else 
            redirect to '/'
        end 
    end 
    #logs user out and clears the current session.
    
end #end of UsersController 