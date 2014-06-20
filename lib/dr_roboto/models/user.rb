module DrRoboto
  class User < ActiveRecord::Base

    # A User can be an Inspector, a Doctor or anyone else who has some
    # access to the Robots database.
    ROLE_INSPECTOR = 'Inspector'
    ROLE_DOCTOR = 'Doctor'

    validates :role, presence: true, inclusion: { in: [ROLE_INSPECTOR, ROLE_DOCTOR] }
    validates :username, presence: true, length: (1..32), uniqueness: true
    validates :password, presence: true, length: (1..32)
    validates :token, presence: true

    after_initialize :generate_token, if: :new_record?

    private

    def generate_token
      begin
        token = SecureRandom.hex(16)
      end while User.where(token: token).exists?
      self.token = token
    end

  end
end