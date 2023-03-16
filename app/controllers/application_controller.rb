class ApplicationController < ActionController::Base
    add_flash_types :danger, :info, :warning, :success
    
    before_action :set_current_user
    def set_current_user
      # finds user with session data and stores it if present
      Current.user = User.find_by(_id: session[:user_id].to_s.split('"')[3]) if session[:user_id]

    end
    def get_user_id
      user_id_aux = session[:user_id].to_s.split('"')[3] if session[:user_id]
    end
    def require_user_logged_in!
      # allows only logged in user
      redirect_to sign_in_path, info: 'You must be signed in' if Current.user.nil?
    end
end
