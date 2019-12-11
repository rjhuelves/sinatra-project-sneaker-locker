class SneakersController < ApplicationController

    get '/sneakers' do 
        if logged_in?
            sneakers = Sneaker.all
            @user = User.find(session[:user_id])
            @user_sneakers = sneakers.select do |sneaker|
                sneaker.user_id == @user.id 
            end
            erb :'sneakers/index'
        else
            redirect to '/login'
        end 
    end 

    get '/sneakers/new' do 
        if logged_in?
            erb :'sneakers/new'
        else 
            redirect to '/login'
        end 
    end 

    post '/sneakers' do
        if logged_in?
            if params[:brand] == "" || params[:model] == "" || params[:colorway] == "" || params[:cost] == ""
                redirect to 'sneakers/new'
            else
                @sneaker = current_user.sneakers.build(brand: params[:brand], model: params[:model], colorway: params[:colorway], cost: params[:cost])
                if @sneaker.save
                    redirect to "sneakers/#{@sneaker.id}"
                else 
                    redirect to 'sneakers/new'
                end 
            end 
        else 
            redirect to '/login'
        end 
    end 

    get '/sneakers/:id' do 
        if logged_in?
            @sneaker = Sneaker.find(params[:id])
            erb :'sneakers/show'
        else 
            redirect to '/login'
        end 
    end 

    get '/sneakers/:id/edit' do 
        if logged_in?
            @sneaker = Sneaker.find(params[:id])
            if @sneaker && @sneaker.user == current_user
                erb :'sneakers/edit'
            else
                redirect to '/sneakers'
            end 
        else
            redirect to '/login'
        end 
    end 

    patch '/sneakers/:id' do 
        if logged_in?
            if params[:brand] == "" || params[:model] == "" || params[:colorway] == "" || params[:cost] == ""
                redirect to "/sneakers/#{params[:id]}/edit"
            else
                @sneaker = Sneaker.find(params[:id])
                if @sneaker && @sneaker.user == current_user
                    if @sneaker.update(brand: params[:brand], model: params[:model], colorway: params[:colorway], cost: params[:cost])
                        redirect to "/sneakers/#{@sneaker.id}"
                    else 
                        redirect to "/sneakers/#{@sneaker.id}/edit"
                    end 
                else 
                    redirect to '/sneakers'
                end 
            end
        else 
            redirect to '/login'
        end 
    end  

    delete '/sneakers/:id/delete' do 
        if logged_in?
            @sneaker = Sneaker.find(params[:id])
            if @sneaker && @sneaker.user == current_user
                @sneaker.delete
            end 
            redirect to '/sneakers'
        else
            redirect to '/login'
        end 
    end 


end #end of SneakersController 