class Robot < ActiveRecord::Base
  has_many :maintenance_records

  belongs_to :current_maintenance_record,
    class_name: MaintenanceRecord,
    foreign_key: 'current_maintenance_record_id'

  def features
    current_maintenance_record.try(:features)
  end

  def maintain(features)
    maintenance_records.build(features: features).tap {|maintenance_record|
      self.current_maintenance_record = maintenance_record
      self.save
    }
  end
end
