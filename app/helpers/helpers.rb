class Helpers

    def self.current_user(session)
        @user = User.find(session[:id])
    end

    def self.is_logged_in?(session)
        if current_user(session).id == session[:id]
            true
        else
            false
        end
    end
end
