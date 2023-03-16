class User
    include Mongoid::Document
    include Mongoid::Attributes::Dynamic
    include ActiveModel::SecurePassword
    include ActiveModel::Validations

    include Role

    has_many :collections, dependent: :destroy

    has_many :invitations, dependent: :destroy
    has_many :invCollections, dependent: :destroy
    has_many :notifications, dependent: :destroy
    has_secure_password

    field :password_digest, type: String
    field :email, type: String
    field :role, type: String
    
    validates :email, presence: true, uniqueness: true
    validates :password_digest, presence: true
    

    def pending_invitations
        invitations = Invitation.where(friend_id: id, confirmed: false).pluck(:id)
        return invitations
    end

    def pending_invitations_collection
        invitations = InvCollection.where(friend_id: id, confirmed: false).pluck(:id)
        return invitations
    end

    def pending_notifications
        notifications = Notification.where(friend_id: id).pluck(:id)
        return notifications
    end

    def friends
        friends_i_sent_invitation = Invitation.where(user_id: id, confirmed: true).pluck(:friend_id)
        friends_i_got_invitation = Invitation.where(friend_id: id, confirmed: true).pluck(:user_id)
        ids = friends_i_sent_invitation + friends_i_got_invitation
        users = []
        for id in ids
            users << User.find(id)
        end
        return users
    end

    def friend_with?(user)
        Invitation.confirmed_record?(id, user.id)
    end

    def send_invitation(user)
        invitations.create(friend_id: user.id)
    end

    def send_invitation_collection(user, collection_id)
        invCollections.create(friend_id: user, collection_id: collection_id)
    end

    def collections_i_shared
        ids_collections = InvCollection.where(user_id: id, confirmed: true).pluck(:collection_id)
        collections = []
        for id in ids_collections
            collections << Collection.find(id)
        end
        return collections
    end

    def collections_friend_shared
        ids_collections = InvCollection.where(friend_id: id, confirmed: true).pluck(:collection_id)
        collections = []
        for id in ids_collections
            collections << Collection.find(id)
        end
        return collections
    end
end
