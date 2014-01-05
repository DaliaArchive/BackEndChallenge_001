require_relative '../lib/robot_store'
require 'awesome_print'

class Robot < Hash
  def initialize(attrs)
    @attrs = attrs
  end

  def self.create!(attrs)
    Robot.new(attrs)
  end
  
  def save
    if @attrs["name"]
      @attrs.merge!("last_update" => Time.now)
      if store.find_by_name(@attrs["name"])
        store.update(@attrs["name"], @attrs)
      else
        store.create(@attrs)
      end
    else
      {"status" => "error", "info" => "Cannot save robot without name"}
    end
  end
  
  def self.find(name)
    existing_robot = store.find_by_name(name)
    existing_robot = existing_robot ? Robot.new(existing_robot.delete_if {|k, v| k == "_id"}) : nil
  end
  
  def to_json
    @attrs.to_json
  end
  
  def [](key)
    @attrs[key]
  end
  
  private
    
  def store
    @@store ||= RobotStore.new
    @@store
  end 
  
  def self.store
    @@store ||= RobotStore.new
    @@store
  end 
end