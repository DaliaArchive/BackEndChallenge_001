@robot_history.each_with_index do |(created_at, changes), index|
  type = index == 0 ? 'create' : 'update'
  json.set! created_at do
    json.type type
    json.changes do
      changes.each do |change|
        json.set! change[:key], change[:value_old].to_s => change[:value_new]
      end
    end
  end
end
