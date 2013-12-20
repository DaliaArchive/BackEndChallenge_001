require 'paper_trail'

module DrRoboto
  class RobotAttribute < ActiveRecord::Base

    belongs_to :robot, touch: true

    has_paper_trail # Provides versioning

    validates :robot_id, presence: true
    validates :name, presence: true, length: (1..32)

    # Produces an array of hashes containing all previous changes to the current 
    # attribute.
    #
    # @return [Array<Hash>] provided keys: event (create|update|destroy), value, changed_at
    def history
      versions.map do |version|
        old = version.reify
        { event: version.event, value: old.present? ? old.value : nil, changed_at: version.created_at }
      end
    end

    def to_hash
      { name => value }
    end

    class << self
      def update_or_create_from_hash(robot, h)
        h.map do |k, v|
          RobotAttribute.where(robot: robot, name: k).first_or_initialize.tap do |a|
            a.value = v
            a.save!
          end
        end
      end
    end

  end
end