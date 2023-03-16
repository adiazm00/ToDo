class InvCollection
  include Mongoid::Document
  include Mongoid::Timestamps

  field :friend_id, type: String
  field :confirmed, type: Mongoid::Boolean, default: :false
  field :collection_id, type: String

  belongs_to :user

  def accept
    self.update(confirmed: 'true')
  end

  def refuse
    self.destroy
  end
end