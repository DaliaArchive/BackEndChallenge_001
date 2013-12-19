class Guest
  def self.find_or_initialize(name)
    Guest.new(name: name)
  end

  attr_reader :name, :attributes

  def initialize(params)
    @name = params[:name]
    @attributes = {}
  end
  
end
