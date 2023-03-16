class TasksController < ApplicationController
  #before_action :set_task, only: %i[ show edit update destroy ]

  def create
    if Current.user
      @collection = Collection.find(params[:collection_id])
      if task_params[:title] != "" || task_params[:description] != ""
        @task = @collection.tasks.create(task_params)
        respond_to do |format|
          if @task.save
            format.html { redirect_to collection_path(@collection), success: "Task was successfully created." }
            format.json { render :show, status: :created, location: @task }
          else
            redirect_to new_collection_task_path(params[:collection_id]), danger: 'Cant create the task'
          end
        end
      else
        redirect_to new_collection_task_path(params[:collection_id]), danger: 'You must complete the fields'
      end
    else 
      redirect_to sign_in_path, info: 'You must be logged in to access some of the systems functionalities'
    end
  end

  def destroy
    if Current.user
    @collection = Collection.find(params[:collection_id])
    @task = @collection.tasks.find(params[:id])
    if @task == nil 
      redirect_to root_path, danger: "The requested task is not available"
    end
    @task.destroy
    redirect_to collection_path(@collection), status: 303, success: 'The task has been destroyed successfully'
    else 
      redirect_to sign_in_path, info: 'You must be logged in to access some of the systems functionalities'
    end
  end

  def update
    if Current.user
      @collection = Collection.find(params[:collection_id])
      @task = Task.find(params[:id])
      if @task.update(task_params)
        redirect_to collection_task_path(@collection, @task), success: 'The task has been updated successfully'
      else
        render :edit, status: :unprocessable_entity, danger: 'The task could not be updated'
      end
      if @task == nil 
        redirect_to root_path, danger: "The requested task is not available"
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
      @collection = Collection.find(params[:collection_id])
      @task = Task.find(params[:id])
      if @task == nil 
        redirect_to root_path, danger: "The requested task is not available"
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
      @collection = Collection.find(params[:collection_id])
      @task = Task.find(params[:id])
      if @task == nil 
        redirect_to root_path, danger: "The requested task is not available"
      end
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
      @collection = Collection.find(params[:collection_id])
    else 
      redirect_to sign_in_path, info: 'You must be logged in to access some of the systems functionalities'
    end
  end

  private
    def task_params
      params.require(:task).permit(:title, :description, :priority, :status)
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end
end
