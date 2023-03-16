
class Collection
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include ActiveModel::Validations
  belongs_to :user

  field :title, type: String
  field :description, type: String
  has_many :tasks, dependent: :destroy
  validates :title, presence: true
  validates :description, presence: true

end
