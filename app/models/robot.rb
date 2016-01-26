class Robot < ActiveRecord::Base

  has_many :revisions
  has_many :features, through: :revisions

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
