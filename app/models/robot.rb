class Robot < ActiveRecord::Base
  has_many :maintenance_records

  belongs_to :current_maintenance_record,
    class_name: MaintenanceRecord,
    foreign_key: 'current_maintenance_record_id'

  def features
    current_maintenance_record.try(:features)
  end

  # Create maintenance_record and its features
  #
  # == Parameters:
  #   [Feature.new(key: 'foo', value: 'var')]
  def maintain(features)
    maintenance_records.build.tap {|maintenance_record|
      maintenance_record.features = features
      maintenance_record.save_features
      self.current_maintenance_record = maintenance_record
      self.save
    }
  end
end
