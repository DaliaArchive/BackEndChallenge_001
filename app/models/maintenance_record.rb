class MaintenanceRecord < ActiveRecord::Base
  belongs_to :robot, autosave: true
  has_many :features

  before_save :specify_action

  def feature_diffs
    Feature.diffs(previous.try(:features), self.features)
  end

  # Merge previous and new features and save them
  #
  def save_features
    if previous.present?
      merged = previous.features_hash.merge(self.features_hash)
      features.clear
      merged.each do |key, value|
        features.build(key: key, value: value).save
      end
    else
      features.each(&:save)
    end
  end

  def features_hash
    features.each_with_object({}.with_indifferent_access) do |feature, sum|
      sum[feature.key] = feature.value
    end
  end

  private

  # Previous maintenance_record of this instance
  def previous
    if robot.persisted? && robot.maintenance_records.present?
      robot.
        maintenance_records.
        order(updated_at: :desc).
        where("maintenance_records.updated_at < ?", self.updated_at || Time.now).
        first
    end
  end

  def specify_action
    self.action = previous.present? ? 'update' : 'create'
  end
end
