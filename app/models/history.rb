class History
  include Mongoid::Document

  field :type, type: String
  field :created_at, type: DateTime

  validates :type, inclusion: { in: ['create', 'update'] }

  embedded_in :robot
  embeds_many :attribute_changes

  def as_json(options)
    { created_at.strftime("%Y-%m-%d %H:%M:%S") => { type: type, changes: attribute_changes } }
  end
end
