require "mongo"

class RobotStore

  def initialize
    collections = open
    @robots = collections["robots"]
    @history = collections["history"]
  end

  def create(attributes)
    robot = attributes.reject {|_, v| v.nil?}
    begin
      @robots.insert(robot)
      {"status" => "ok", "info" => "Entry created"}
    rescue Mongo::OperationFailure
      {"status" => "error", "info" => "Internal Error"}
    end
  end
    
  def update(name, attributes)
    begin
      @robots.update({"name" => name}, {"$set" => attributes})
      {"status" => "ok", "info" => "Entry updated"}
    rescue Mongo::OperationFailure        
      raise RuntimeError # Error updating data in db
      {"status" => "error", "info" => "Internal Error"}
    end
  end
  
  def create_history(attributes)
    robot = attributes.reject {|_, v| v.nil?}
    begin
      @history.insert(robot)
      {"status" => "ok", "info" => "Entry created"}
    rescue Mongo::OperationFailure
      {"status" => "error", "info" => "Internal Error"}
    end    
  end
    
  def find_by_name(name)
    r = @robots.find("name" => name).to_a.first
    r ? r : nil
  end

  def history_by_name(name)
    r = @history.find("name" => name).to_a
    r.empty? ? nil : r
  end  
  
  def find_all
    @robots.find.to_a
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