module DrRoboto
  class User < ActiveRecord::Base

    ROLE_INSPECTOR = 'Inspector'

    validates :role, presence: true, inclusion: { in: [ROLE_INSPECTOR] }
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