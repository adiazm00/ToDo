class InvCollectionsController < ApplicationController
    def show_collections
        if Current.user
            @user = User.find_by(id: get_user_id)
            myCollections = Collection.where(:user_id => get_user_id).pluck(:id)
            collectionsShared = InvCollection.where(:confirmed => true, :user_id => @user.id).pluck(:collection_id)
            allCollections = myCollections + collectionsShared
            @collections = []
            for id in allCollections
                @collections << Collection.find_by(id: id)
            end
            @collectionsFriend = Collection.where(:user_id => params[:id])
            @friend = User.find(params[:id])
        else 
            redirect_to sign_in_path, info: 'You must be logged in to access some of the systems functionalities'
        end
    end

    def collections_shared
        if Current.user
            @user = User.find_by(id: get_user_id)
            myCollections = Collection.where(:user_id => get_user_id).pluck(:id)
            collectionsShared = InvCollection.where(:confirmed => true, :user_id => @user.id).pluck(:collection_id)
            allCollections = myCollections + collectionsShared
            @collections = []
            for id in allCollections
                @collections << Collection.find_by(id: id)
            end
            @friend = User.find(params[:id])
            @collectionsSharedByMe = InvCollection.where(:user_id => params[:id], :friend_id => @user.id, :confirmed => true)
            @collectionsSharedWithMe = InvCollection.where(:user_id => @user.id, :friend_id => params[:id], :confirmed => true)
        else 
            redirect_to sign_in_path, info: 'You must be logged in to access some of the systems functionalities'
        end
    end

    def request_collection
        @user = User.find_by(id: get_user_id)
        @collection = Collection.find(params[:id])
        if InvCollection.find_by(collection_id: @collection.id, user_id: get_user_id) == nil
            @user.send_invitation_collection(@collection.user_id, @collection.id)
            Notification.create(user_id: @user.id, friend_id: @collection.user_id, message: "Has sent you a collection request. You can find it in the 'friends' section")
            redirect_to '/search_user', success: 'The request has been sent successfully'
        else
            redirect_to '/search_user', danger: 'The request already exists'
        end
    end

    def accept_invitation
        @invitation = InvCollection.find(params[:id])
        @invitation.accept
        Notification.create(user_id: @invitation.friend_id, friend_id: @invitation.user_id, message: "Has accepted your request to share the collection '"+Collection.find(@invitation.collection_id).title+"'")
        redirect_to search_user_path, success: 'Request accepted'
    end

    def refuse_invitation
        @invitation = InvCollection.find(params[:id])
        Notification.create(user_id: @invitation.friend_id, friend_id: @invitation.user_id, message: "Has rejected your request to share the collection '"+Collection.find(@invitation.collection_id).title+"'")
        @invitation.refuse
        redirect_to search_user_path, success: 'Request rejected'
    end

    def delete_invitation
        @invitation = InvCollection.find(params[:id])
        @user = User.find_by(id: get_user_id)
        if User.find(@invitation.user_id) == @user
            Notification.create(user_id: @user.id, friend_id: @invitation.friend_id, message: "Has stopped sharing the collection '"+Collection.find(@invitation.collection_id).title+"' with you")
        else
            Notification.create(user_id: @user.id, friend_id: @invitation.user_id, message: "Has stopped sharing the collection '"+Collection.find(@invitation.collection_id).title+"' with you")
        end
        @invitation.destroy
        redirect_to search_user_path, success: 'Collection shared deleted'
    end
end
