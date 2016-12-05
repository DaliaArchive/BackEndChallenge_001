class History
  include Mongoid::Document

  field :type, type: String
  field :created_at, type: DateTime

  validates :type, inclusion: { in: ['create', 'update'] }
end
