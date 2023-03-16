class InvitationsController < ApplicationController
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

    def accept_invitation
        @invitation = Invitation.find(params[:id])
        @invitation.accept
        Notification.create(user_id: @invitation.friend_id, friend_id: @invitation.user_id, message: "Has accepted your friendship request")
        redirect_to search_user_path, success: 'Request accepted'
    end

    def refuse_invitation
        @invitation = Invitation.find(params[:id])
        Notification.create(user_id: @invitation.friend_id, friend_id: @invitation.user_id, message: "Has rejected your friendship request")
        @invitation.refuse
        redirect_to search_user_path, success: 'Request rejected'
    end

    def delete_invitation
        @invitation = Invitation.find(params[:id])
        if(@invitation.friend_id == get_user_id)
            InvCollection.where(user_id: @invitation.user_id, friend_id: get_user_id).destroy
            InvCollection.where(friend_id: @invitation.user_id, user_id: get_user_id).destroy
            Notification.create(user_id: @invitation.friend_id, friend_id: @invitation.user_id, message: "Has removed you from friends")
        else
            InvCollection.where(user_id: @invitation.friend_id, friend_id: get_user_id).destroy
            InvCollection.where(friend_id: @invitation.friend_id, user_id: get_user_id).destroy
            Notification.create(user_id: @invitation.user_id, friend_id: @invitation.friend_id, message: "Has removed you from friends")
        end
        @invitation.destroy
        redirect_to search_user_path, sucess: 'Deleted friend'
    end
end
