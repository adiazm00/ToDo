class Notification
  include Mongoid::Document
  include Mongoid::Timestamps
  field :friend_id, type: String
  field :message, type: String
  belongs_to :user
end
