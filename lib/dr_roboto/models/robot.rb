module DrRoboto
  class Robot < ActiveRecord::Base

    has_many :robot_attributes

    validates :name, presence: true, length: (1..32)

    def as_json(options = {})
      super(only: [:name, :updated_at])
    end

  end
end