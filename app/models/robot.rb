class Robot
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic


  validates :name, uniqueness: true

  field :name, type: String

  def attributes=(values)
    if values.is_a?(Hash)
      values.each do |key, value|
        write_attribute(key, value)
      end
    end
  end
end
