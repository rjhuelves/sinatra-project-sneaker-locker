class User < ActiveRecord::Base
    has_many :sneakers

    has_secure_password
    validates :username, uniqueness: {message: "Username is taken"}
    #validate for presence get rid of params 

    def slug
        username.downcase.gsub(" ", "-")
    end 

    def self.find_by_slug(slug)
        User.all.find{|user| user.slug == slug}
    end 

end 