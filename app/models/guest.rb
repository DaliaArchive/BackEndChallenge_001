class Guest < ApplicationRecord

  validates :name, presence: true, uniqueness: true

end
