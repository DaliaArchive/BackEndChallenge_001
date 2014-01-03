require "mongo"


class RobotStore

  def initialize
    collections = open
    @robots = collections["robots"]
  end

  def create(attributes)
    robot = attributes.reject {|_, v| v.nil?}
    begin
      @robots.insert(robot)
    rescue Mongo::OperationFailure
      nil
    end
  end
  
  def update(id, attributes)
    begin
      @robots.update({"_id" => id}, {"$set" => attributes})
    rescue Mongo::OperationFailure
      raise RuntimeError # Error updating data in db
    end
  end
  
  def find(id)
    r = @robots.find_one("_id" => id)
    r ? r : nil
  end
  
  def find_by_name(name)
    r = @robots.find("name" => name).to_a.first
    r ? r : nil
  end
  
  def robot_store
    
  end 
  
  private

  def open
    case ENV["RACK_ENV"]
    when "test"
      Mongo::Connection.new("localhost")["test"]
    else
      Mongo::Connection.new("localhost")["development"]
    end                                                #TODO: set up production db
  end

end