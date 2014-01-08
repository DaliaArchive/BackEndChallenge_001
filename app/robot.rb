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
        update_history
        store.update(@attrs["name"], @attrs)
      else
        create_history
        store.create(@attrs)
      end
    else
      {"status" => "error", "info" => "Cannot save robot without name"}
    end
  end
  
  def self.find(name)
    existing_robot = store.find_by_name(name)
    result = existing_robot.nil? ? nil : existing_robot.delete_if {|k, v| k == "_id"}
    {"status" => "ok", "robot" => result}
  end
  
  def self.find_history(name)
    history = store.history_by_name(name)
    if history.nil?
      {"status" => "ok", "info" => "No such robot in database"}
    else
      response = history.map{|history_entry| history_entry.delete_if{|key,value| key == "_id"}}
      {"status" => "ok", "history" => response}
    end
  end
  
  def self.index
    robots = store.find_all
    if robots.empty?
      {"status" => "ok", "info" => "No robots in database"}
    else
      response = robots.map{|robot| robot.select{|key,value| %w{name last_update}.include?(key)}}
      {"status" => "ok", "robots" => response}
    end
  end
  
  def jsonize
    @attrs.to_json
  end
  
  def [](key)
    @attrs[key]
  end
  
  def create_history
    store.create_history(initial_history_hash)
  end
  
  def initial_history_hash
    change_log = {}
    @attrs.dup.delete_if{|key,value| %w{name, last_update}.include? key }
      .map{|key,value| change_log[key] = "[] -> [#{value}]"}
    new_history_entry(change_log)
  end
  
  def update_history
    update_scope = store.find_by_name(@attrs["name"])
    change_log = format_deep_difference(difference(update_scope, @attrs))
    store.create_history(history_entry(change_log))
  end

  def difference (origin, updated)
    result = {}
    updated.each do |key,value|
      if origin[key].kind_of?(Hash) &&  updated[key].kind_of?(Hash)
        partial_difference = difference(origin[key], updated[key])
        result[key] = partial_difference unless partial_difference.empty?
      else
        unless origin[key] == updated[key] || key == "last_update"
          result[key] = "[#{origin[key]}] -> [#{updated[key]}]"
        end
      end
    end
    result
  end
  
  def format_deep_difference(dif)
    dif = dif.map do|key,value|
      if dif[key].kind_of?(Hash) 
        {key => dif[key].to_s}
      else
        {key => dif[key]}
      end
    end
    {}.tap{ |result| dif.each{ |hash| hash.each{ |key,value| result[key] = value } } }
  end
  
  
  private
  
  def new_history_entry(change_log)
    history_entry(true, change_log)
  end
    
  def history_entry(initial = false, change_log)
    type = initial ? "create" : "update"
    {
      "name" => @attrs["name"], 
      "type" => type,
      "time" => @attrs["last_update"],
      "log" => change_log
    }
  end
  
  def store
    @@store ||= RobotStore.new
    @@store
  end 
  
  def self.store
    @@store ||= RobotStore.new
    @@store
  end 
end