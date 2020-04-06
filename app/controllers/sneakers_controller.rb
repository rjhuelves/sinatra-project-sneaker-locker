class SneakersController < ApplicationController

    before_action :get_sneaker, only: [:patch]

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
    #checks if user is logged in. gets user's sneaker index if it's the same user as current session. 

    get '/sneakers/new' do 
        if logged_in?
            erb :'sneakers/new'
        else 
            redirect to '/login'
        end 
    end 
    #checks if logged in. if logged in it gets the page new page/form. 

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
    #if user is logged in and leaves fields empty redirects them to new page again. if user fills out the form correctly, it will save and redirect the show page. 

    get '/sneakers/:id' do 
        if logged_in?
            @sneaker = Sneaker.find(params[:id])
            erb :'sneakers/show'
        else 
            redirect to '/login'
        end 
    end 
    #gets the show page for a sneaker

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
    #gets the edit page for the selected sneaker

    patch '/sneakers/:id' do 
        # if logged_in?
        #     if params[:brand] == "" || params[:model] == "" || params[:colorway] == "" || params[:cost] == ""
        #         redirect to "/sneakers/#{params[:id]}/edit"
        #     else
        #         @sneaker = Sneaker.find(params[:id])
        #         if @sneaker && @sneaker.user == current_user # allow_user_edit?(@sneaker)
        #             if @sneaker.update(brand: params[:brand], model: params[:model], colorway: params[:colorway], cost: params[:cost])
        #                 redirect to "/sneakers/#{@sneaker.id}"
        #             else 
        #                 redirect to "/sneakers/#{@sneaker.id}/edit"
        #             end 
        #         else 
        #             redirect to '/sneakers'
        #         end 
        #     end
        # else 
        #     redirect to '/login'
        # end 
        @sneaker = Sneaker.find(params[:id])
        allow_user_edit?(@sneaker)
    end  
    #updates and saves the edit page if filled out correctly 

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
    #deletes the sneaker if it belongs to the current user. If it's not current user's sneaker it redirects them to their index page. 

    private 

    def get_sneaker 
        @sneaker = Sneaker.find(params[:id])
    end 

    def sneaker_params 
        params.require(:model).permit(:brand, :model, :colorway, :cost)
    end 

end #end of SneakersController 

# allow_user_edit?(object)
# allow_user_edit?(@sneaker) should return true or false based if the current user owns this sneaker