class Robot < ActiveRecord::Base  

  def update(params)     
    actual_robot_params = self.attrs          
    new_robot_params = actual_robot_params.merge params
    self.update_attributes!({ attrs: new_robot_params })        
    self.historify params
    self
  end

  def get_history
    h = self.history     
    updates = h.keys.sort
    all_changes = { }
    updates.each_with_index do |up, index|
      up_change = { }
      type = index == 0 ? 'create' : 'update'
      changes = { }
      self.history[up].each { |k,v| changes[k] = index == 0 ? "'' to '#{v}'" : "'#{self.history[updates[index - 1]][k]}' to '#{v}'" }
      up_change= { type: type, changes: changes }
      all_changes[up] = up_change
    end
    all_changes
  end

  def historify(params)
    h = self.history.clone if self.history        
    h ||= {}
    h[self.updated_at] = params          
    self.update_attributes!({ history: h })  
  end

  def self.create(id, params = nil)        
    robot_params = { id: id, attrs: params }
    super robot_params    
    robot = self.find id
    robot.historify(params) unless params.nil?
    robot
  end  

end
