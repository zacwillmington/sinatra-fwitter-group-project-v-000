class Helpers

    def self.current_user(session)
        if session[:id]
            @user = User.find(session[:id])
        else
            nil
        end
    end

    def self.is_logged_in?(session)
        if session[:id] &&  self.current_user(session).id == session[:id]
            true
        else
            false
        end
    end
end
