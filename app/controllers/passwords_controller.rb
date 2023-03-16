class PasswordsController < ApplicationController
    before_action :require_user_logged_in!
    def edit 
      if Current.user
      @user = User.find_by(id: get_user_id)
      myCollections = Collection.where(:user_id => get_user_id).pluck(:id)
      collectionsShared = InvCollection.where(:confirmed => true, :user_id => @user.id).pluck(:collection_id)
      allCollections = myCollections + collectionsShared
      @collections = []
      for id in allCollections
        @collections << Collection.find_by(id: id)
      end
      else 
        redirect_to sign_in_path, info: 'You must be logged in to use the application'
      end
    end

    def update
      if Current.user
      # update user password
        myCollections = Collection.where(:user_id => get_user_id).pluck(:id)
        collectionsShared = InvCollection.where(:confirmed => true, :user_id => get_user_id).pluck(:collection_id)
        allCollections = myCollections + collectionsShared
        @collections = []
        for id in allCollections
          @collections << Collection.find_by(id: id)
        end
        if Current.user.update(password_params)
          redirect_to root_path, success: 'The password has been updated successfully'
        else
          redirect_to edit_password_path, danger: 'The password could not be updated'
        end
      else 
        redirect_to sign_in_path, info: 'You must be logged in to use the application'
      end
    end
    private
    def password_params
      params.require(:user).permit(:password, :password_confirmation)
    end
  end