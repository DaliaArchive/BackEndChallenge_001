class Robot
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic

  validates :name, uniqueness: true

  field :name, type: String
  field :last_update, type: DateTime

  before_save :set_last_update

  def attributes=(values)
    if values.is_a?(Hash)
      values.each do |key, value|
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
end
