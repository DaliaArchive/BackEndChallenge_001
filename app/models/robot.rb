class Robot < ActiveRecord::Base

  has_many :revisions
  has_many :features, through: :revisions

  def self.list

    robots = Robot.includes(:revisions).all

    robots.map do |robot|

      if robot.revisions.empty?

        last_update = robot.created_at.to_formatted_s(:db)

      else

        last_update = robot.revisions.last.created_at.to_formatted_s(:db)

      end

      { name: robot.name, last_update: last_update }

    end

  end



  def current_revision

    features = self.features.group(:name).select(:name,:value).as_json

    features.map! do |feature|
      {
        feature["name"] => feature["value"]
      }
    end

    features.to_json

  end

end
