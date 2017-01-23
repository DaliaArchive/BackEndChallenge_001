class Robot < ActiveRecord::Base
  attr_accessible :name, :robot_datas
  validates :name, :presence => true, :uniqueness => true
                    
  has_many :robothistories

  def self.create_robot(create_data, id)
    create_data.each do |key, value|
      if value.present?
        if key == "name"
          @robothistory = Robothistory.new
          @robothistory.status='create'
          @robothistory.robot_id = id
          @robothistory.field=key
          @robothistory.value=value
          @robothistory.save
        else
          value.each do |datakey, datavalue|
            @robothistory = Robothistory.new
            @robothistory.status='create'
            @robothistory.robot_id = id
            @robothistory.field=datakey
            @robothistory.value=datavalue
            @robothistory.save
          end
        end 
      end
    end
  end
  
  def self.update_checking(update_hash,id)
    if update_hash.present?
      update_hash.each do |key, value|
        if value.present?
          @robothistory = Robothistory.new 
          @robothistory.status='update'
          @robothistory.robot_id = id
          @robothistory.field=key
          @robothistory.value=value
          @robothistory.save
        end
      end
    end
  end
end
