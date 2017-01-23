class User < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :email, :password, :password_confirmation, 
                  :temp_password

  validates :email, :first_name, :last_name, :presence =>true
  validates_uniqueness_of :email

end