require 'bcrypt'

class User < ActiveRecord::Base
    has_many :tweets
    has_secure_password

    def slug
        username = self.username.gsub(" ", "-").downcase
    end

    def self.find_by_slug(slug)
         self.find_by(:username => slug.split("-").join(" "))
    end
end
