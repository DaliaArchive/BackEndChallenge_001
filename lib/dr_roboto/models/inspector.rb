module DrRoboto
  class Inspector < User

    default_scope { where(role: ROLE_INSPECTOR) }

    after_initialize :set_defaults

    private

    def set_defaults
      self.role = ROLE_INSPECTOR
    end

  end
end