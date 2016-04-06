json.array!(@maintenance_records) do |maintenance_record|
  json.extract! maintenance_record, :updated_at, :action
  json.changes do
    maintenance_record.feature_diffs.each do |key, features|
      json.set! key do
        json.array!(features.map(&:value))
      end
    end
  end
end
