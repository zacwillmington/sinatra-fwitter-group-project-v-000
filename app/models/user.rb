require 'bcrypt'

class User < ActiveRecord::Base
    has_many :tweets
    has_secure_password

    def slug
        username = self.username.gsub(" ", "-").downcase
    end


end
