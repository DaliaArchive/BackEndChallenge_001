class Robot
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic

  validates :name, uniqueness: true

  field :name, type: String
  field :last_update, type: DateTime

  embeds_many :histories

  before_save :set_last_update
  before_save :record_history

  def attributes=(values)
    if values.is_a?(Hash)
      values.except(:last_update).each do |key, value|
        write_attribute(key, value)
      end
    end
  end

  def id
    self._id.to_s
  end

  def set_last_update
    self.write_attribute(:last_update, DateTime.now)
  end

  def record_history
    if self.changed?
      history = self.histories.build(created_at: self.last_update)
      history.type = self.new_record? ? 'create' : 'update'
      self.changes.except(:last_update, :_id).each do |key, values|
        history.attribute_changes.build(attribute_name: key, old_value: values[0], new_value: values[1])
      end
    end
  end
end
