class UsersController < ApplicationController

    get 'users/:slug' do 
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

end #end of UsersController 