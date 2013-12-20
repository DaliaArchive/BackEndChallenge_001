require 'dr_roboto/models/user'

module DrRoboto
  module AuthHelper

    def authenticate!(role = DrRoboto::User::ROLE_INSPECTOR)
      raise NotAuthorized unless cookies[:token].present?
      raise NotAuthorized unless User.where(token: cookies[:token], role: role).exists?
    end

  end
end