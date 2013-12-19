require 'pry'
class Guest
  extend Mongo
  include Mongo

  def self.find_or_initialize(name)
    collection = MongoClient.new['test']['guest']
    saved_guest = collection.find(name: name).first
    if(saved_guest)
      Guest.new(saved_guest)
    else
      Guest.new(name: name)
    end
  end

  attr_reader :name, :attributes

  def initialize(params)
    params = HashWithIndifferentAccess.new(params)
    @name = params[:name]
    @attributes = params[:attributes] || {}
  end

  def save!
    collection = MongoClient.new['test']['guest']
    collection.insert(name: @name, attributes: @attributes)
  end

  def self.clean
    MongoClient.new.drop_database('test')
  end
  
end
