#include ActiveModel::Serialization
class RobotSerializer < ActiveModel::Serializer
  attributes :name, :last_update

  def last_update
    object.updated_at.strftime("%Y-%m-%d")
  end
end