class Robot < ActiveRecord::Base  

  def update(params)     
    actual_robot_params = self.attrs          
    new_robot_params = actual_robot_params.merge params
    self.update_attributes!({ attrs: new_robot_params })        
    self.historify params
    self
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
