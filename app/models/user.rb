require 'bcrypt'

class User < ActiveRecord::Base
    has_many :tweets
    has_secure_password

    def slug
        username = self.username.gsub(" ", "-").downcase
    end

    def self.find_by_slug(slug)
        slugname = slug.split("-").join(" ")
         self.find_by(:username => slugname)
    end
end
