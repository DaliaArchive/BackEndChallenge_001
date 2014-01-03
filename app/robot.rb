require_relative '../lib/robot_store'

class Robot

  class << self
    attr_accessor :store
  end
  
  @store = RobotStore.new
  
  def self.save(robot)
    entry = robot.merge("last_update" => Time.now)
    existing_robot = @store.find_by_name(entry["name"])
    existing_robot.nil? ? @store.create(entry) : @store.update(existing_robot["_id"], entry) 
  end
  
  def self.find(name)
    existing_robot = @store.find_by_name(name)
    existing_robot ? existing_robot.delete_if{|k,v| k == "_id"} : {} 
  end
    
end