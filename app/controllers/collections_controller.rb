class CollectionsController < ApplicationController
  #before_action :set_collection, only: %i[ show edit update destroy ]

  
  def index
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

  def home
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

  def create
    if Current.user
      @user = User.find_by(id: get_user_id)
      if collection_params[:title] != "" || collection_params[:description] != ""
        @collection = @user.collections.create(collection_params)
        respond_to do |format|
          if @collection.save
            format.html { redirect_to root_path, success: 'The collection has been created successfully' }
            format.json { render :show, status: :created, location: @collection }
          else
            redirect_to new_user_collection_path(@user), danger: 'Cant create the collection'
          end
        end
      else
        redirect_to new_user_collection_path(@user), danger: 'You must complete the fields'
      end
    else 
      redirect_to sign_in_path, info: 'You must be logged in to access some of the systems functionalities'
    end
  end


  def show
    if Current.user
      @user = User.find_by(id: get_user_id)
      myCollections = Collection.where(:user_id => get_user_id).pluck(:id)
      collectionsShared = InvCollection.where(:confirmed => true, :user_id => @user.id).pluck(:collection_id)
      allCollections = myCollections + collectionsShared
      @collections = []
      for id in allCollections
        @collections << Collection.find_by(id: id)
      end
      @collection = Collection.find(params[:id])
      if @collection == nil 
        redirect_to root_path, danger: "The requested collection is not available"
      end
    else 
      redirect_to sign_in_path, info: 'You must be logged in to access some of the systems functionalities'
    end
  end
  
  def update
    if Current.user
      @user = User.find_by(id: get_user_id)
      @collection = Collection.find(params[:id])
      if @collection == nil 
        redirect_to root_path, danger: "The requested collection is not available"
      end
      if @collection.update(collection_params)
        redirect_to user_collection_path(@user, @collection), success: 'The collection has been updated successfully'
      else
        redirect_to user_collection_path(@user, @collection), danger: 'The collection could not be updated'
      end
      
    else 
      redirect_to sign_in_path, info: 'You must be logged in to access some of the systems functionalities'
    end
  end

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
      @collection = Collection.find(params[:id])
      if @collection == nil 
        redirect_to root_path, danger: "The requested collection is not available"
      end
    else 
      redirect_to sign_in_path, info: 'You must be logged in to access some of the systems functionalities'
    end
  end
  
  def destroy
    if Current.user
      @user = User.find_by(id: get_user_id)
      myCollections = Collection.where(:user_id => get_user_id).pluck(:id)
      collectionsShared = InvCollection.where(:confirmed => true, :user_id => @user.id).pluck(:collection_id)
      allCollections = myCollections + collectionsShared
      @collections = []
      for id in allCollections
        @collections << Collection.find_by(id: id)
      end
      @collection = Collection.find(params[:id])
      if @collection == nil 
        redirect_to root_path, danger: "The requested collection is not available"
      end
      invCollections = InvCollection.where(collection_id: @collection.id)
      invCollections.destroy #Si da error es porque habria que eliminar una a una
      @collection.destroy
      redirect_to root_path, status: :see_other, success: 'The collection has been destroyed successfully'
    else 
      redirect_to sign_in_path, info: 'You must be logged in to access some of the systems functionalities'
    end
  end


  def new
    if Current.user
      @user = User.find_by(id: get_user_id)
      myCollections = Collection.where(:user_id => get_user_id).pluck(:id)
      collectionsShared = InvCollection.where(:confirmed => true, :user_id => @user.id).pluck(:collection_id)
      allCollections = myCollections + collectionsShared
      @collections = []
      for id in allCollections
        @collections << Collection.find_by(id: id)
      end
      @collection = Collection.new
    else 
      redirect_to sign_in_path, info: 'You must be logged in to access some of the systems functionalities'
    end
  end
  private
  # Only allow a list of trusted parameters through.
  def collection_params
    params.require(:collection).permit(:title, :description)
  end
  
  private
  # Use callbacks to share common setup or constraints between actions.
  def set_collection
    @collection = Collection.find(params[:id])
  end


end
