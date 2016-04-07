class History
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :transaction_type, type: String
  field :changed_attribs, type: Array, :default => Array.new
  
  embedded_in :robot, :inverse_of => :histories
  
  def self.save_robot_history(robot, old_attribs, new_attribs, type)
    changed_attribs_array = get_changed_attributes(old_attribs, new_attribs)
    changed_attribs_hash = {
      transaction_type: type,
      changed_attribs: changed_attribs_array
    } unless changed_attribs_array.blank?
    
    robot.histories.create(changed_attribs_hash) unless changed_attribs_hash.blank?
  end
  
  def self.get_changed_attributes(old_attribs, new_attribs)
    changed_attribs_array = []
    new_attribs.each do |k, v|
      changed_attrib = {}
      if (old_attribs.key?(k) and old_attribs[k] != v) or !old_attribs.key?(k)
        changed_attrib[:key] = k
        changed_attrib[:new_value] = v
        changed_attrib[:old_value] = old_attribs[k].to_s
      end
      changed_attribs_array << changed_attrib unless changed_attrib.blank?
    end
    changed_attribs_array
  end
  
  
end
