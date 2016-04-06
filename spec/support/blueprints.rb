require 'machinist/active_record'

Robot.blueprint do
end

MaintenanceRecord.blueprint do
  action { 'create' }
end

Feature.blueprint do
  key { "key_#{sn}" }
  value { sn }
end
