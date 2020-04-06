class Sneaker < ActiveRecord::Base

    belongs_to :user 
    #validates for presence 
end 