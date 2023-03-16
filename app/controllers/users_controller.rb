class UsersController < ApplicationController

  #def new
  #  @users = User.all
  #  @user = User.new
  #end

  def index
    if Current.user
      if (User.find(get_user_id).role == 'admin')
        @user = User.find_by(id: get_user_id)
        @users = User.all
        myCollections = Collection.where(:user_id => get_user_id).pluck(:id)
        collectionsShared = InvCollection.where(:confirmed => true, :user_id => @user.id).pluck(:collection_id)
        allCollections = myCollections + collectionsShared
        @collections = []
        for id in allCollections
          @collections << Collection.find_by(id: id)
        end
        @tasks = Task.all
      else 
        redirect_to root_path, info: 'You must be admin to access that functionality'
      end
    else 
      redirect_to sign_in_path, info: 'You must be logged in to access some of the systems functionalities'
    end
  end

  def show
    if Current.user
      if (User.find(get_user_id).role == 'admin')
        @user = User.find_by(id: get_user_id)
        myCollections = Collection.where(:user_id => get_user_id).pluck(:id)
        collectionsShared = InvCollection.where(:confirmed => true, :user_id => @user.id).pluck(:collection_id)
        allCollections = myCollections + collectionsShared
        @collections = []
        for id in allCollections
          @collections << Collection.find_by(id: id)
        end
        @userAux = User.find(params[:id])
        @collectionsUser = Collection.where(:user_id => params[:id])
      else 
        redirect_to root_path, info: 'You must be admin to access that functionality'
      end
    else 
      redirect_to sign_in_path, info: 'You must be logged in to access some of the systems functionalities'
    end
  end

  def notifications
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
      redirect_to sign_in_path, info: 'You must be logged in to access some of the systems functionalities'
    end
  end

  #def create
  #  if Current.user
  #    @user = User.new(user_params)
  #    if @user.save
  #      redirect_to "/collections#index", success: "The account has been created successfully."
  #    else
  #      redirect_to new_user_path, danger: "The username or email is already in use."
  #    end
  #  else 
  #    redirect_to sign_in_path, info: 'You must be logged in to access some of the systems functionalities'
  #  end
  #end

  def update
    if Current.user
      @user = User.find(params[:id])
      if @user.update(user_update)
        redirect_to users_path, success: 'The user role has been updated successfully'
      else
        redirect_to users_path, danger: "Could not change user role"
      end
    else 
      redirect_to sign_in_path, info: 'You must be logged in to access some of the systems functionalities'
    end
  end

  def destroy
    if Current.user
      @user = User.find(params[:id])
      InvCollection.where(friend_id: params[:id]).destroy
      Invitation.where(friend_id: params[:id]).destroy
      Notification.where(friend_id: params[:id]).destroy
      @user.destroy
      redirect_to root_path, success: "Your account has been successfully destroyed"
    else 
      redirect_to sign_in_path, info: 'You must be logged in to access some of the systems functionalities'
    end
  end

  def destroy_user_admin
    if Current.user
      @user = User.find(params[:id])
      InvCollection.where(friend_id: params[:id]).destroy
      Invitation.where(friend_id: params[:id]).destroy
      Notification.where(friend_id: params[:id]).destroy
      @user.destroy
      redirect_to root_path, success: "Your account has been successfully destroyed"
    else 
      redirect_to sign_in_path, info: 'You must be logged in to access some of the systems functionalities'
    end
  end

  private
    def user_params
      params.require(:user).permit(:email, :password)
    end

    private
    def user_update
      params.require(:user).permit( :email, :role)
    end
end
