class Invitation
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :friend_id, type: String
  field :confirmed, type: Mongoid::Boolean, default: :false

  belongs_to :user

  def self.reacted?(id1, id2)
    case1 = !Invitation.where(user_id: id1, friend_id: id2).empty?
    case2 = !Invitation.where(user_id: id2, friend_id: id1).empty?
    case1 || case2
  end

  def self.confirmed_record?(id1, id2)
    case1 = !Invitation.where(user_id: id1, friend_id: id2, confirmed:true).empty?
    case2 = !Invitation.where(user_id: id2, friend_id: id1, confirmed:true).empty?
    case1 || case2
  end

  def self.find_invitation?(id1, id2)
    if Invitation.where(user_id: id1, friend_id: id2, confirmed: true).empty?
      Invitation.where(user_id: id2, friend_id: id1, confirmed: true)[0].id
    else
      Invitation.where(user_id: id1, friend_id: id2, confirmed: true)[0].id
    end
  end
  
  def accept
    self.update(confirmed: 'true')
  end

  def refuse
    self.destroy
  end
end
