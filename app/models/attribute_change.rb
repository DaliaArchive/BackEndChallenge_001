class AttributeChange
  include Mongoid::Document

  field :attribute_name, type: String
  field :old_value, type: String
  field :new_value, type: String

  embedded_in :history

  def as_json(options = {})
    { attribute_name => [old_value, new_value] }
  end
end
