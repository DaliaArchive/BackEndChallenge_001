class Revision < ActiveRecord::Base
  self.inheritance_column = nil
  belongs_to :robot
  has_many :features

  # Return an Hash with the features of a revision organized
  # by name and value
  def get_features

    self.features.inject({}) do |hash, feature|

      name = feature[:name]

      value = feature[:value]

      hash[name] = value

      hash

    end

  end

end
