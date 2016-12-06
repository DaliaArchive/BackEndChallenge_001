class History
  include Mongoid::Document

  field :type, type: String
  field :created_at, type: DateTime

  validates :type, inclusion: { in: ['create', 'update'] }

  embedded_in :robot
  embeds_many :attribute_changes
end
