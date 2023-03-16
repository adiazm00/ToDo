class NotificationsController < ApplicationController

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

    def delete_notification
        @notification = Notification.where(:id => params[:id])
        @notification.destroy
        redirect_to '/index_notifications', success: 'Notification marked as seen'
    end

    def delete_all_notifications
        Notification.where(:friend_id => get_user_id).destroy
        redirect_to '/index_notifications', success: 'All notifications marked as seen'
    end
end
