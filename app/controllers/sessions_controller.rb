class SessionsController < ApplicationController
    def new; end
    def create
      myCollections = Collection.where(:user_id => get_user_id).pluck(:id)
      collectionsShared = InvCollection.where(:confirmed => true, :user_id => get_user_id).pluck(:collection_id)
      allCollections = myCollections + collectionsShared
      @collections = []
      for id in allCollections
        @collections << Collection.find_by(id: id)
      end
      user = User.find_by(email: params[:email])
      # finds existing user, checks to see if user can be authenticated
      if user.present? && user.authenticate(params[:password])
      # sets up user.id sessions
        session[:user_id] = user.id
        redirect_to root_path, success: 'Logged in successfully'
      else
        redirect_to sign_in_path, danger: 'Invalid email or password'
      end 
    end
    
    def destroy
      myCollections = Collection.where(:user_id => get_user_id).pluck(:id)
      collectionsShared = InvCollection.where(:confirmed => true, :user_id => get_user_id).pluck(:collection_id)
      allCollections = myCollections + collectionsShared
      @collections = []
      for id in allCollections
        @collections << Collection.find_by(id: id)
      end
      # deletes user session
      session[:user_id] = nil
      redirect_to sign_in_path, status: :see_other, success: 'Logged out successfully'
    end
  end