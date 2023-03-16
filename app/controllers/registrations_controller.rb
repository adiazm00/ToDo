class RegistrationsController < ApplicationController
    def new
      @user = User.new
    end

    def create
      @user = User.new
      @user.email = user_params[:email]
      @user.password = user_params[:password]
      @user.password_confirmation = user_params[:password_confirmation]
      if @user.email != "admin@admin.com"
        @user.role = 'user'
      else
        @user.role = 'admin'
      end
      if @user.save
      # stores saved user id in a session
        session[:user_id] = @user.id
        redirect_to root_path, success: 'The account has been created successfully'
      else
        redirect_to sign_up_path, danger: 'The account could not be created'
      end
    end

    private
    def user_params
      # strong parameters
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
end