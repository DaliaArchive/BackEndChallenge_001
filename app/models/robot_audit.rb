class RobotAudit
  include Mongoid::Document
  include Mongoid::Timestamps
  field :robot_id, type: String
  field :type, type: String
  field :changed_attribute_values, type: Hash
  index({ robot_id: 1 }, { unique: true, name: 'robot id_index'})
end