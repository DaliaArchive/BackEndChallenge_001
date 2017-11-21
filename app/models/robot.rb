class Robot < ApplicationRecord
  has_many :robot_attributes

  def attributes_hash
    robot_attributes.map { |attribute| [attribute.key, attribute.value] }.to_h
  end
end
