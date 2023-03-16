class Task
  #include Mongoid::Timestamps
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include ActiveModel::Validations

  include Priority
  include Status
  belongs_to :Collection

  field :title, type: String
  field :description, type: String

  validates :title, presence: true
  validates :description, presence: true
  end
  