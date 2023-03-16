class SearchController < ApplicationController

    def search_user 
        if Current.user
            @user = User.find_by(id: get_user_id)
            @userFound = ""
            if params[:email] != nil
                @userFound = User.find_by(email: params[:email])
            end
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
end
