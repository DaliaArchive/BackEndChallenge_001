class Robot < ActiveRecord::Base

  has_many :revisions
  has_many :features, through: :revisions
end
