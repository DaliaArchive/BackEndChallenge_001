require 'pry'
class Guest
  extend Mongo
  include Mongo

  def self.find_or_initialize(name)
    if(guest = find(name))
      guest
    else
      Guest.new(name: name)
    end
  end

  def self.find(name)
    collection = MongoClient.new['test']['guest']
    saved_guest = collection.find(name: name).first
    saved_guest.present? ? Guest.new(saved_guest) : nil
  end

  attr_reader :name, :attributes

  def initialize(params)
    params = HashWithIndifferentAccess.new(params)
    @name = params[:name]
    @attributes = params[:attributes] || {}
    @id = params[:_id]
  end

  def save!
    collection = MongoClient.new['test']['guest']
    if(@id.nil?)
      collection.insert(to_params)
    else
      collection.update({"_id" => @id}, to_params)
    end
  end

  def self.clean
    MongoClient.new.drop_database('test')
  end

  def == other
    self.class == other.class and
      self.name == other.name and
      self.attributes == other.attributes
  end

  def merge_attributes(attributes)
    self.attributes.merge!(attributes)
  end

  private
  def to_params
    {name: @name, attributes: @attributes}
  end
  
end
